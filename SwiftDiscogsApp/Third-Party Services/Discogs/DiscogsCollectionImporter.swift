//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import os
import PromiseKit
import Stylobate
import SwiftDiscogs

public class DiscogsCollectionImporter: NSManagedObjectContext {

    public enum ImportError: Error {

        /// If no Discogs folder with an ID of `0` was retrieved. Since *every*
        /// user's collection has a `0` folder, this probably indicates that
        /// `Discogs.collectionFolders()` failed.
        case noAllFolderWasFound

        /// If a `weak self` in a block became `nil` before the block was
        /// executed. This is theoretically possible if the block operation
        /// was queued for a long time.
        case selfWentOutOfScope

    }

    public typealias CoreDataFieldsByID = [Int: CustomField]

    public typealias CoreDataFoldersByID = [Int: Folder]

    public typealias CoreDataItemsByID = [Int: CollectionItem]

    // MARK: - Properties

    private var coreDataFieldsByID = CoreDataFieldsByID()

    private var coreDataFoldersByID = CoreDataFoldersByID()

    private var coreDataItemsByID = CoreDataItemsByID()

    private var discogs: Discogs = DiscogsManager.discogs

    private var discogsFields = [SwiftDiscogs.CollectionCustomField]()

    private var discogsFolders = [SwiftDiscogs.CollectionFolder]()

    public weak var importerDelegate: ImportableServiceDelegate?

    public weak var service: ImportableService?

    private var importQueue = DispatchQueue(label: "DiscogsCollectionImporter",
                                            qos: .background,
                                            attributes: .concurrent,
                                            autoreleaseFrequency: .inherit,
                                            target: nil)

    // MARK: - Import Functions

    public func importDiscogsCollection(forUserName userName: String) -> Promise<Void> {
        importerDelegate?.willBeginImporting(fromService: service)

        return discogs.customCollectionFields(forUserName: userName)
            .then(on: importQueue) { (discogsFieldsResult) -> Promise<CoreDataFieldsByID> in
            self.discogsFields = discogsFieldsResult.fields ?? []
            self.importerDelegate?.update(importedItemCount: 1, totalCount: 6, forService: self.service)

            return self.createCoreDataFields(self.discogsFields)
        }.then(on: importQueue) { _ -> Promise<CollectionFolders> in
            self.importerDelegate?.update(importedItemCount: 2, totalCount: 6, forService: self.service)

            return self.discogs.collectionFolders(forUserName: userName)
        }.then(on: importQueue) { (discogsFoldersResult) -> Promise<CoreDataFoldersByID> in
            self.discogsFolders = discogsFoldersResult.folders
            self.importerDelegate?.update(importedItemCount: 3, totalCount: 6, forService: self.service)

            return self.createCoreDataFolders(forDiscogsFolders: discogsFoldersResult.folders)
        }.then(on: importQueue) { (coreDataFoldersByID) -> Promise<[CollectionFolderItem]> in
            let masterFolderID = 0

            guard let masterFolder = coreDataFoldersByID[masterFolderID] else {
                throw ImportError.noAllFolderWasFound
            }

            self.importerDelegate?.update(importedItemCount: 4, totalCount: 6, forService: self.service)

            return self.downloadDiscogsItems(forUserName: userName,
                                             inFolderWithID: 0,
                                             expectedItemCount: Int(masterFolder.expectedItemCount))
        }.then(on: importQueue) { (discogsItems) -> Promise<CoreDataItemsByID> in
            print("Importing \(discogsItems.count) Discogs collection items.")
            self.importerDelegate?.update(importedItemCount: 5, totalCount: 6, forService: self.service)

            return self.createCoreDataItems(forDiscogsItems: discogsItems)
        }.then(on: importQueue) { _ -> Promise<Void>  in
            self.importerDelegate?.update(importedItemCount: 6, totalCount: 6, forService: self.service)
            return self.addCoreDataItemsToOtherFolders(forUserName: userName)
        }.then(on: importQueue) { _ -> Promise<Void>  in
            self.importerDelegate?.willFinishImporting(fromService: self.service)
            try self.save()

            return Promise<Void>()
        }
    }

    /// Import the custom fields that the user has defined. The
    /// `CustomCollectionField.fetchOrCreateEntity()` is a bit different from
    /// the other managed objects' `fetchOrCreate()`s because there are two
    /// custom field types (dropdown and textarea), and the appropriate one has
    /// to be created.
    public func createCoreDataFields(_ discogsFields: [CollectionCustomField]) -> Promise<CoreDataFieldsByID> {
        return Promise<CoreDataFieldsByID> { (seal) in
            coreDataFieldsByID = [:]

            try discogsFields.forEach { [weak self] (discogsField) in
                guard let self = self else {
                    throw ImportError.selfWentOutOfScope
                }

                let coreDataField = try CustomField.fetchOrCreateEntity(fromDiscogsField: discogsField, inContext: self)
                coreDataFieldsByID[discogsField.id] = coreDataField
            }

            seal.fulfill(coreDataFieldsByID)
        }
    }

    public func createCoreDataFolders(forDiscogsFolders discogsFolders: [CollectionFolder]) -> Promise<CoreDataFoldersByID> {
        return Promise<CoreDataFoldersByID> { [weak self] (seal) in
            coreDataFoldersByID = [:]

            guard let self = self else {
                throw ImportError.selfWentOutOfScope
            }

            try discogsFolders.forEach { (discogsFolder) in
                let request: NSFetchRequest<Folder> = Folder.fetchRequest(sortDescriptors: [(\Folder.folderID).sortDescriptor()],
                                                                          predicate: NSPredicate(format: "folderID == \(discogsFolder.id)"))
                let coreDataFolder: Folder = try self.fetchOrCreate(withRequest: request) { (folder) in
                    folder.update(withDiscogsFolder: discogsFolder)
                }

                coreDataFoldersByID[discogsFolder.id] = coreDataFolder
            }

            seal.fulfill(coreDataFoldersByID)
        }
    }

    public func downloadDiscogsItems(forUserName userName: String,
                                     inFolderWithID folderID: Int,
                                     expectedItemCount: Int) -> Promise<[CollectionFolderItem]> {
        let pageSize = 500
        let pageCount = (expectedItemCount / pageSize) + 1

        let pagePromises: [Promise<CollectionFolderItems>] = pageCount.times.map { (pageNumber) -> Promise<CollectionFolderItems> in
            return discogs.collectionItems(inFolderID: folderID,
                                           userName: userName,
                                           pageNumber: pageNumber + 1,
                                           resultsPerPage: pageSize)
        }

        return when(resolved: pagePromises).then { (discogsItemsResults) in
            return Promise<[CollectionFolderItem]> { (seal) in
                let discogsItems = discogsItemsResults.reduce([CollectionFolderItem]()) { (allItems, result)  in
                    switch result {
                    case .fulfilled(let discogsCollectionItems):
                        return allItems + (discogsCollectionItems.releases ?? [])
                    default:
                        return allItems
                    }
                }

                seal.fulfill(discogsItems)
            }
        }
    }

    public func createCoreDataItems(forDiscogsItems discogsItems: [SwiftDiscogs.CollectionFolderItem]) -> Promise<CoreDataItemsByID> {
        return Promise<CoreDataItemsByID> { (seal) in
            coreDataItemsByID = [:]

            try discogsItems.forEach { (discogsItem) in
                let request: NSFetchRequest<CollectionItem> = CollectionItem.fetchRequest(sortDescriptors: [],
                                                                                          predicate: CollectionItem.uniquePredicate(forReleaseVersionID: discogsItem.id))
                let coreDataItem = try self.fetchOrCreate(withRequest: request) { (item) in
                    do {
                        try item.update(withDiscogsItem: discogsItem,
                                        coreDataFields: coreDataFieldsByID,
                                        inContext: self)
                    } catch {
                        os_log(.debug, "Failed to update CoreData fields for Discogs item %d", discogsItem.id)
                    }
                }

                coreDataItemsByID[discogsItem.id] = coreDataItem
            }

            seal.fulfill(coreDataItemsByID)
        }
    }

    func addCoreDataItemsToOtherFolders(forUserName userName: String) -> Promise<Void> {
        let folderPromises: [Promise<Void>] = discogsFolders.filter { $0.id != 0 }.map { (discogsFolder) -> Promise<Void> in
            guard let coreDataFolder = self.coreDataFoldersByID[discogsFolder.id] else {
                return Promise<Void>()
            }

            return downloadDiscogsItems(forUserName: userName,
                                 inFolderWithID: discogsFolder.id,
                                 expectedItemCount: discogsFolder.count).done { (discogsItems) in
                                    print("Discogs folder \"\(discogsFolder.name)\" should have \(discogsItems.count) items:")
                                    var coreDataItemCount = 0

                                    discogsItems.forEach { (discogsItem) in
                                        if let coreDataItem = self.coreDataItemsByID[discogsItem.id] {
                                            print(" [\(coreDataItemCount + 1)] \(discogsItem.basicInformation!.title) (\(discogsItem.id))")
                                            coreDataItem.addToFolders(coreDataFolder)
                                            coreDataItemCount += 1
                                        } else {
                                            print("Failed to find or create a Core Data item for Discogs item \(discogsItem.id)!")
                                        }
                                    }
                                 }
        }

        return when(resolved: folderPromises).then { (results) in
            return Promise<Void> { (seal) in
                results.forEach { (result) in
                    switch result {
                    case .rejected(let error):
                        seal.reject(error)
                    default:
                        break
//                        seal.fulfill()
                    }
                }
            }
        }
    }

}

public extension SwiftDiscogsApp.CollectionItem {

    static func uniquePredicate(forReleaseVersionID releaseVersionID: Int) -> NSPredicate {
        return NSPredicate(format: "releaseVersionID == \(releaseVersionID)")
    }

    func update(withDiscogsItem discogsItem: SwiftDiscogs.CollectionFolderItem,
                coreDataFields: DiscogsCollectionImporter.CoreDataFieldsByID,
                inContext context: NSManagedObjectContext) throws {
        self.rating = Int16(discogsItem.rating)
        self.releaseVersionID = Int64(discogsItem.id)

        // Import the custom fields.
        try discogsItem.notes?.forEach { (discogsNote) in
            guard let discogsItemID = discogsItem.basicInformation?.id,
                let coreDataField = coreDataFields[discogsNote.fieldId] else {
                return
            }

            let fieldPredicate = CollectionItemField.uniquePredicate(forReleaseVersionID: discogsItemID,
                                                                     fieldID: discogsNote.fieldId)
            let request: NSFetchRequest<CollectionItemField> = CollectionItemField.fetchRequest(sortDescriptors: [],
                                                                                                predicate: fieldPredicate)
            _ = try context.fetchOrCreate(withRequest: request) { (field) in
                field.update(withDiscogsNote: discogsNote,
                            customField: coreDataField,
                            collectionItem: self)
            }
        }
    }

}

public extension SwiftDiscogsApp.CollectionItemField {

    static func uniquePredicate(forReleaseVersionID releaseVersionID: Int,
                                fieldID: Int) -> NSPredicate {
        return NSPredicate(format: "collectionItem.releaseVersionID == \(Int64(releaseVersionID))")
            + NSPredicate(format: "customField.id == \(Int64(fieldID))")
    }

    func update(withDiscogsNote discogsNote: SwiftDiscogs.CollectionFolderItem.Note,
                customField: SwiftDiscogsApp.CustomField,
                collectionItem: SwiftDiscogsApp.CollectionItem) {
        self.value = discogsNote.value
        self.customField = customField
        self.collectionItem = collectionItem
    }

}

public extension SwiftDiscogsApp.Folder {

    func update(withDiscogsFolder discogsFolder: SwiftDiscogs.CollectionFolder) {
        self.folderID = Int64(discogsFolder.id)
        self.name = discogsFolder.name
        self.expectedItemCount = Int64(discogsFolder.count)
    }

}
