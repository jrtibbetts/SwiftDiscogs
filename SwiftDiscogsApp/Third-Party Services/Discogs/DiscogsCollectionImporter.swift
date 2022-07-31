//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import os
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

    public typealias CoreDataFieldsById = [Int: CustomField]

    public typealias CoreDataFoldersById = [Int: Folder]

    public typealias CoreDataItemsById = [Int: CollectionItem]

    // MARK: - Properties

    private var coreDataFieldsById = CoreDataFieldsById()

    private var coreDataFoldersById = CoreDataFoldersById()

    private var coreDataItemsById = CoreDataItemsById()

    private var discogs: Discogs = DiscogsManager.discogs

    private var discogsFields = [SwiftDiscogs.CollectionCustomField]()

    private var discogsFolders = [SwiftDiscogs.CollectionFolder]()

    public weak var importerDelegate: ImportableServiceDelegate?

    public weak var service: ImportableService?

    // MARK: - Import Functions

    public func importDiscogsCollection(forUserName userName: String) async throws -> Void {
        importerDelegate?.willBeginImporting(fromService: service)

        discogsFields = try await discogs.customCollectionFields(forUserName: userName).fields ?? []
        _ = try createCoreDataFields(discogsFields)
        importerDelegate?.update(importedItemCount: 1, totalCount: 6, forService: self.service)

        discogsFolders = try await discogs.collectionFolders(forUserName: userName).folders
        _ = try createCoreDataFolders(forDiscogsFolders: discogsFolders)
        importerDelegate?.update(importedItemCount: 2, totalCount: 6, forService: self.service)

        importerDelegate?.update(importedItemCount: 3, totalCount: 6, forService: self.service)
        let masterFolderID = 0

        guard let masterFolder = coreDataFoldersById[masterFolderID] else {
            throw ImportError.noAllFolderWasFound
        }

        importerDelegate?.update(importedItemCount: 4, totalCount: 6, forService: self.service)

        let discogsItems = try await downloadDiscogsItems(forUserName: userName,
                                                          inFolderWithID: 0,
                                                          expectedItemCount: Int(masterFolder.expectedItemCount))
        _ = try createCoreDataItems(forDiscogsItems: discogsItems)
        importerDelegate?.update(importedItemCount: 5, totalCount: 6, forService: self.service)

        _ = try addCoreDataItemsToOtherFolders(forUserName: userName)
        importerDelegate?.update(importedItemCount: 6, totalCount: 6, forService: self.service)

        importerDelegate?.willFinishImporting(fromService: self.service)
    }

    /// Import the custom fields that the user has defined. The
    /// `CustomCollectionField.fetchOrCreateEntity()` is a bit different from
    /// the other managed objects' `fetchOrCreate()`s because there are two
    /// custom field types (dropdown and textarea), and the appropriate one has
    /// to be created.
public func createCoreDataFields(_ discogsFields: [CollectionCustomField]) async throws -> CoreDataFieldsById {
    coreDataFieldsById = [:]

    try discogsFields.forEach { [weak self] (discogsField) in
        guard let self = self else {
            throw ImportError.selfWentOutOfScope
        }

        let coreDataField = try CustomField.fetchOrCreateEntity(fromDiscogsField: discogsField, inContext: self)
        coreDataFieldsById[discogsField.id] = coreDataField
    }

    return coreDataFieldsById
}
}

    public func createCoreDataFolders(forDiscogsFolders discogsFolders: [CollectionFolder]) throws -> CoreDataFoldersById {
        coreDataFoldersById = [:]

        try discogsFolders.forEach { (discogsFolder) in
            let request: NSFetchRequest<Folder> = Folder.fetchRequest(sortDescriptors: [(\Folder.folderID).sortDescriptor()],
                                                                      predicate: NSPredicate(format: "folderID == \(discogsFolder.id)"))
            let coreDataFolder: Folder = try fetchOrCreate(withRequest: request) { (folder) in
                folder.update(withDiscogsFolder: discogsFolder)
            }

            coreDataFoldersById[discogsFolder.id] = coreDataFolder
        }
    }

    public func downloadDiscogsItems(forUserName userName: String,
                                     inFolderWithID folderID: Int,
                                     expectedItemCount: Int) async throws -> [CollectionFolderItem] {
        let pageSize = 500
        let pageCount = (expectedItemCount / pageSize) + 1
        var folderItems = [CollectionFolderItem]()

        pageCount.times { (pageNumber) async throws in
            let items = try await DiscogsManager.discogs.collectionItems(inFolderID: folderID,
                                                                         userName: userName,
                                                                         pageNumber: pageNumber + 1,
                                                                         resultsPerPage: pageSize).releases
            folderItems.append(items)
        }
    }

    public func createCoreDataItems(forDiscogsItems discogsItems: [SwiftDiscogs.CollectionFolderItem]) async throws -> CoreDataItemsById {
            coreDataItemsById = [:]

            try discogsItems.forEach { (discogsItem) in
                let request: NSFetchRequest<CollectionItem> = CollectionItem.fetchRequest(sortDescriptors: [],
                                                                                          predicate: CollectionItem.uniquePredicate(forReleaseVersionID: discogsItem.id))
                let coreDataItem = try self.fetchOrCreate(withRequest: request) { (item) in
                    do {
                        try item.update(withDiscogsItem: discogsItem,
                                        coreDataFields: coreDataFieldsById,
                                        inContext: self)
                    } catch {
                        os_log(.debug, "Failed to update CoreData fields for Discogs item %d", discogsItem.id)
                    }
                }

                coreDataItemsById[discogsItem.id] = coreDataItem
            }

            seal.fulfill(coreDataItemsById)
        }
    }

    func addCoreDataItemsToOtherFolders(forUserName userName: String) async throws {
        discogsFolders.filter { $0.id != 0 }.map { (discogsFolder) in
            guard let coreDataFolder = coreDataFoldersById[discogsFolder.id] else {
                return
            }

            let discogsItems = try await downloadDiscogsItems(forUserName: userName,
                                                              inFolderWithID: discogsFolder.id,
                                                              expectedItemCount: discogsFolder.count)
            print("Discogs folder \"\(discogsFolder.name)\" should have \(discogsItems.count) items:")
            var coreDataItemCount = 0

            discogsItems.forEach { (discogsItem) in
                if let coreDataItem = coreDataItemsById[discogsItem.id] {
                    print(" [\(coreDataItemCount + 1)] \(discogsItem.basicInformation!.title) (\(discogsItem.id))")
                    coreDataItem.addToFolders(coreDataFolder)
                    coreDataItemCount += 1
                } else {
                    print("Failed to find or create a Core Data item for Discogs item \(discogsItem.id)!")
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
                coreDataFields: DiscogsCollectionImporter.CoreDataFieldsById,
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
