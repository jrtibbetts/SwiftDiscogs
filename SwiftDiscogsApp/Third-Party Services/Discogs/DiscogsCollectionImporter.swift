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

    typealias CoreDataFieldsByID = [Int16: CustomField]

    typealias CoreDataFoldersByID = [Int64: Folder]

    // MARK: - Properties

    /// The mapping of the fetched or created `CollectionItem`s, keyed by their
    /// `CollectionItem.releaseVersionID`s.
    private var coreDataItems: [Int64: CollectionItem] = [:]

    private var discogsFolders: [Int: SwiftDiscogs.CollectionFolder] = [:]

    /// The mapping of the Discogs `CollectionFolderItem`s, keyed by their
    /// IDs.
    private var discogsItems: [Int: SwiftDiscogs.CollectionFolderItem] = [:]

    // MARK: - Import Functions

    public func importDiscogsCollection(forUserName userName: String) -> Promise<Void> {
        return importDiscogsCustomFields(forUserName: userName).then { (coreDataFields) -> Promise<CoreDataFoldersByID> in
            self.importDiscogsFolders(forUserName: userName)
        }.done { (coreDataFolders) in
            guard let masterFolder = coreDataFolders[Int64(0)] else {
                throw ImportError.noAllFolderWasFound
            }

            self.importDiscogsItems(forUserName: userName, inMasterFolder: masterFolder)
        }
    }

    /// Import the custom fields that the user has defined. The
    /// `CustomCollectionField.fetchOrCreateEntity()` is a bit different from
    /// the other managed objects' `fetchOrCreate()`s because there are two
    /// custom field types (dropdown and textarea), and the appropriate one has
    /// to be created.
    private func importDiscogsCustomFields(forUserName userName: String) -> Promise<CoreDataFieldsByID> {
        return DiscogsManager.discogs.customCollectionFields(forUserName: userName).then { (discogsFieldsResponse) -> Promise<CoreDataFieldsByID> in
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

    private func importDiscogsFolders(forUserName userName: String) -> Promise<CoreDataFoldersByID> {
        return DiscogsManager.discogs.collectionFolders(forUserName: userName).then { [weak self] (discogsFoldersResponse) -> Promise<CoreDataFoldersByID> in
            return Promise<CoreDataFoldersByID> { (seal) in
                var coreDataFolders = CoreDataFoldersByID()

                guard let self = self else {
                    seal.reject(ImportError.selfWentOutOfScope)
                    return
                }

                try discogsFoldersResponse.folders.forEach { (discogsFolder) in
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
    }

    private func importDiscogsItems(forUserName userName: String,
                                    inMasterFolder masterFolder: Folder) {
        let count = Int(masterFolder.expectedItemCount)
        let pageSize = 100
        let pageCount = (count / pageSize) + 1
        let folderID = Int(masterFolder.folderID)

        (1..<pageCount).forEach { (pageNumber) in
            DiscogsManager.discogs.collectionItems(inFolderID: folderID,
                                                   userName: userName,
                                                   pageNumber: pageNumber,
                                                   resultsPerPage: pageSize).done { (itemsResult) in
                }.cauterize()
        }
    }

}

public extension SwiftDiscogsApp.CollectionItem {

    func update(withDiscogsItem discogsItem: SwiftDiscogs.CollectionFolderItem,
                inContext context: NSManagedObjectContext) throws {
        self.rating = Int16(discogsItem.rating)
        self.releaseVersionID = Int64(discogsItem.id)

//        try discogsItem.notes?.forEach { (discogsNote) in
//            let predicate = CollectionItemField.uniquePredicate(forReleaseVersionID: discogsItem.id,
//                                                                fieldID: discogsNote.fieldId)
//            let request: NSFetchRequest<CollectionItemField> = CollectionItemField.fetchRequest(sortDescriptors: [],
//                                                                                                predicate: predicate)
//            _ = try context.fetchOrCreate(withRequest: request) { (note) in
//
//            }
//        }
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

