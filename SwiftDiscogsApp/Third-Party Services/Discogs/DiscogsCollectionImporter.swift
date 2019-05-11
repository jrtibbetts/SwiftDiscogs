//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
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

    public typealias CoreDataFieldsByID = [Int16: CustomField]

    public typealias CoreDataFoldersByID = [Int64: Folder]

    public typealias CoreDataItemsByID = [Int64: CollectionItem]

    // MARK: - Properties

    public var importerDelegate: ImportableServiceDelegate?

    public weak var service: ImportableService?

    private var coreDataFieldsByID = CoreDataFieldsByID()

    private var coreDataFoldersByID = CoreDataFoldersByID()

    private var coreDataItemsByID = CoreDataItemsByID()

    private var discogs: Discogs = DiscogsManager.discogs

    private var discogsFields = [SwiftDiscogs.CollectionCustomField]()

    private var discogsFolders = [SwiftDiscogs.CollectionFolder]()

    // MARK: - Import Functions

    public func importDiscogsCollection(forUserName userName: String) -> Promise<Void> {
        importerDelegate?.willBeginImporting(fromService: service)

        return discogs.customCollectionFields(forUserName: userName).then { (discogsFieldsResult) -> Promise<CoreDataFieldsByID> in
            self.discogsFields = discogsFieldsResult.fields ?? []

            return self.createCoreDataFields(self.discogsFields)
        }.then { (coreDataFields) in
            self.discogs.collectionFolders(forUserName: userName)
        }.then { (discogsFoldersResult) -> Promise<CoreDataFoldersByID> in
            self.discogsFolders = discogsFoldersResult.folders

            return self.createCoreDataFolders(forDiscogsFolders: discogsFoldersResult.folders)
        }.then { (coreDataFoldersByID) -> Promise<CollectionFolderItems> in
            let masterFolderID = 0

            guard let masterFolder = coreDataFoldersByID[Int64(masterFolderID)] else {
                throw ImportError.noAllFolderWasFound
            }

            return self.discogs.collectionItems(inFolderID: masterFolderID,
                                                userName: userName,
                                                pageNumber: 1,
                                                resultsPerPage: Int(masterFolder.expectedItemCount))
        }.then { (discogsItemsResult) -> Promise<CoreDataItemsByID> in
            guard let discogsItems = discogsItemsResult.releases else {
                return Promise<CoreDataItemsByID> { $0.fulfill(CoreDataItemsByID()) }
            }

            print("Importing \(discogsItems.count) Discogs collection items.")

            return self.createCoreDataItems(forDiscogsItems: discogsItems)
        }.then { [weak self] (coreDataItemsByID) -> Promise<Void> in
            self?.addCoreDataItemsToOtherFolders(forUserName: userName)
            self?.importerDelegate?.willFinishImporting(fromService: self?.service)
            try self?.save()
            
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
                coreDataFieldsByID[Int16(discogsField.id)] = coreDataField
            }

            seal.fulfill(coreDataFieldsByID)
        }
    }

    public func discogsFolders(forUserName userName: String) -> Promise<[CollectionFolder]> {
        return Promise<[CollectionFolder]> { (seal) in
            discogs.collectionFolders(forUserName: userName).done { (foldersResult) in
                seal.fulfill(foldersResult.folders)
                }.catch { (error) in
                    seal.reject(error)
                }
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

                coreDataFoldersByID[coreDataFolder.folderID] = coreDataFolder
            }

            seal.fulfill(coreDataFoldersByID)
        }
    }

    public func createCoreDataItems(forDiscogsItems discogsItems: [SwiftDiscogs.CollectionFolderItem]) -> Promise<CoreDataItemsByID> {
        return Promise<CoreDataItemsByID> { (seal) in
            coreDataItemsByID = [:]

            try discogsItems.forEach { (discogsItem) in
                let request: NSFetchRequest<CollectionItem> = CollectionItem.fetchRequest(sortDescriptors: [],
                                                                                          predicate: CollectionItem.uniquePredicate(forReleaseVersionID: discogsItem.id))
                let coreDataItem = try self.fetchOrCreate(withRequest: request) { (item) in
                    item.update(withDiscogsItem: discogsItem, inContext: self)
                }

                coreDataItemsByID[Int64(discogsItem.id)] = coreDataItem
            }

            seal.fulfill(coreDataItemsByID)
        }
    }

    func addCoreDataItemsToOtherFolders(forUserName userName: String) {
        discogsFolders.filter { $0.id != 0 }.forEach { (discogsFolder) in
            addCoreDataItemsToFolder(discogsFolder.id,
                                     folderItemCount: discogsFolder.count,
                                     userName: userName)
        }
    }

    func addCoreDataItemsToFolder(_ folderID: Int,
                                  folderItemCount: Int,
                                  userName: String) {
        guard let coreDataFolder = self.coreDataFoldersByID[Int64(folderID)] else {
            return
        }

        discogs.collectionItems(inFolderID: folderID,
                                userName: userName,
                                pageNumber: 1,
                                resultsPerPage: folderItemCount).done { (discogsItemsResult) in
                                    discogsItemsResult.releases?.forEach { (discogsItem) in
                                        if let coreDataItem = self.coreDataItemsByID[Int64(folderID)] {
                                            print("Adding item \(discogsItem.id) to folder \(folderID)")
                                            coreDataItem.addToFolders(coreDataFolder)
                                        }
                                    }
        }.cauterize()
    }

}

public extension SwiftDiscogsApp.CollectionItem {

    static func uniquePredicate(forReleaseVersionID releaseVersionID: Int) -> NSPredicate {
        return NSPredicate(format: "releaseVersionID == \(releaseVersionID)")
    }

    func update(withDiscogsItem discogsItem: SwiftDiscogs.CollectionFolderItem,
                inContext context: NSManagedObjectContext) {
        self.rating = Int16(discogsItem.rating)
        self.releaseVersionID = Int64(discogsItem.id)

        // Import the custom fields.
    }

}

public extension SwiftDiscogsApp.CollectionItemField {

    static func uniquePredicate(forReleaseVersionID releaseVersionID: Int,
                                fieldID: Int) -> NSPredicate {
        return SwiftDiscogsApp.CollectionItem.uniquePredicate(forReleaseVersionID: releaseVersionID)
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
