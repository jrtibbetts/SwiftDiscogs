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

    // MARK: - Properties

    /// The mapping of the fetched or created `CollectionItem`s, keyed by their
    /// `CollectionItem.releaseVersionID`s.
    private var coreDataItems: [Int64: CollectionItem] = [:]

    private var discogs: Discogs = DiscogsManager.discogs

    // MARK: - Import Functions

    public func importDiscogsCollection(forUserName userName: String) -> Promise<Void> {
        return importDiscogsCustomFields(forUserName: userName).then { (coreDataFields) -> Promise<CoreDataFoldersByID> in
            self.importDiscogsFolders(forUserName: userName)
            }.then { (coreDataFolders) -> Promise<Void> in
                guard let masterFolder = coreDataFolders[Int64(0)] else {
                    throw ImportError.noAllFolderWasFound
                }

                return self.importDiscogsItems(forUserName: userName,
                                        inMasterFolder: masterFolder).done { (discogsItemsResults) in
//                    discogsItemsResults.forEach { (result) in
//                        result
//                    }
                }
          }
    }

    /// Import the custom fields that the user has defined. The
    /// `CustomCollectionField.fetchOrCreateEntity()` is a bit different from
    /// the other managed objects' `fetchOrCreate()`s because there are two
    /// custom field types (dropdown and textarea), and the appropriate one has
    /// to be created.
    public func importDiscogsCustomFields(forUserName userName: String) -> Promise<CoreDataFieldsByID> {
        return discogs.customCollectionFields(forUserName: userName).then { (discogsFieldsResponse) -> Promise<CoreDataFieldsByID> in
            return Promise<CoreDataFieldsByID> { (seal) in
                var coreDataCustomFields = CoreDataFieldsByID()

                try discogsFieldsResponse.fields?.forEach { [weak self] (discogsField) in
                    guard let self = self else {
                        seal.reject(ImportError.selfWentOutOfScope)
                        return
                    }

                    if let coreDataField = try CustomField.fetchOrCreateEntity(fromDiscogsField: discogsField, inContext: self) {
                        coreDataCustomFields[coreDataField.id] = coreDataField
                    }
                }

                seal.fulfill(coreDataCustomFields)
            }
        }
    }

    public func importDiscogsFolders(forUserName userName: String) -> Promise<CoreDataFoldersByID> {
        return discogs.collectionFolders(forUserName: userName).then { [unowned self] (discogsFoldersResponse) -> Promise<CoreDataFoldersByID> in
            return self.createCoreDataFolders(forDiscogsFolders: discogsFoldersResponse.folders)
        }
    }

    public func createCoreDataFolders(forDiscogsFolders discogsFolders: [CollectionFolder]) -> Promise<CoreDataFoldersByID> {
        return Promise<CoreDataFoldersByID> { [weak self] (seal) in
            var coreDataFolders = CoreDataFoldersByID()

            guard let self = self else {
                seal.reject(ImportError.selfWentOutOfScope)
                return
            }

            try discogsFolders.forEach { (discogsFolder) in
                let request: NSFetchRequest<Folder> = Folder.fetchRequest(sortDescriptors: [(\Folder.folderID).sortDescriptor()],
                                                                          predicate: NSPredicate(format: "folderID == \(discogsFolder.id)"))
                let coreDataFolder: Folder = try self.fetchOrCreate(withRequest: request) { (folder) in
                    folder.update(withDiscogsFolder: discogsFolder)
                }

                coreDataFolders[coreDataFolder.folderID] = coreDataFolder
            }

            seal.fulfill(coreDataFolders)
        }
    }

    public func importDiscogsItems(forUserName userName: String,
                                    inMasterFolder masterFolder: Folder) -> Guarantee<[Result<CollectionFolderItems>]> {
        let count = Int(masterFolder.expectedItemCount)
        let pageSize = 100
        let pageCount = (count / pageSize) + 1
        let folderID = Int(masterFolder.folderID)

        let pagePromises: [Promise<CollectionFolderItems>] = (1..<pageCount).map { (pageNumber) -> Promise<CollectionFolderItems> in
            return discogs.collectionItems(inFolderID: folderID,
                                           userName: userName,
                                           pageNumber: pageNumber,
                                           resultsPerPage: pageSize)

        }

        return when(resolved: pagePromises)
    }

}

public extension SwiftDiscogsApp.CollectionItem {

    func update(withDiscogsItem discogsItem: SwiftDiscogs.CollectionFolderItem,
                inContext context: NSManagedObjectContext) throws {
        self.rating = Int16(discogsItem.rating)
        self.releaseVersionID = Int64(discogsItem.id)

    }

}

public extension SwiftDiscogsApp.CollectionItemField {

    static func uniquePredicate(forReleaseVersionID releaseVersionID: Int,
                                fieldID: Int) -> NSPredicate {
        return NSPredicate(format: "collectionItem.releaseVersionID == \(releaseVersionID)")
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

