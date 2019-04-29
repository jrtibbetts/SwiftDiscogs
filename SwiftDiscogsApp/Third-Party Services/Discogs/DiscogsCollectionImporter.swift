//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import SwiftDiscogs

public class DiscogsCollectionImporter: NSManagedObjectContext {

    // MARK: - Properties

    private var coreDataFolders: [Folder] = []

    /// The mapping of the fetched or created `CollectionItem`s, keyed by their
    /// `CollectionItem.releaseVersionID`s.
    private var coreDataItems: [Int64: CollectionItem] = [:]

    private var coreDataCustomFields: [Int16: CustomField] = [:]

    /// The mapping of the Discogs `CollectionFolderItem`s, keyed by their
    /// IDs.
    private var discogsItems: [Int: SwiftDiscogs.CollectionFolderItem] = [:]

    private var userName = DiscogsService.instance.userName!

    // MARK: - Import Functions

    public func importDiscogsCollection() {
        importDiscogsCustomFields()
        importDiscogsFolders()
        importDiscogsItems()
    }

    public func importCollectionItem(fromDiscogsItem discogsItem: SwiftDiscogs.CollectionFolderItem) throws {

    }

    /// Import the custom fields that the user has defined. The
    /// `CustomCollectionField.fetchOrCreateEntity()` is a bit different from
    /// the other managed objects' `fetchOrCreate()`s because there are two
    /// custom field types (dropdown and textarea), and the appropriate one has
    /// to be created.
    public func importDiscogsCustomFields() {
        coreDataCustomFields = [:]

        DiscogsManager.discogs.customCollectionFields(forUserName: userName).done { [weak self] (discogsFieldsResponse) in
            try discogsFieldsResponse.fields?.forEach { [weak self] (discogsField) in
                guard let self = self else { return }

                if let coreDataField = try discogsField.fetchOrCreateEntity(inContext: self) {
                    self.coreDataCustomFields[coreDataField.position] = coreDataField
                }
            }
        }.cauterize()
    }

    public func importDiscogsFolders() {
        coreDataFolders = []

        DiscogsManager.discogs.collectionFolders(forUserName: userName).done { [weak self] (discogsFoldersResponse) in
            guard let self = self else { return }

            try discogsFoldersResponse.folders.forEach { (discogsFolder) in
                let request: NSFetchRequest<Folder> = Folder.fetchRequest(sortDescriptors: [(\Folder.folderID).sortDescriptor()])
                let coreDataFolder: Folder = try self.fetchOrCreate(withRequest: request) { (folder) in
                    folder.update(withDiscogsFolder: discogsFolder)
                }

                self.coreDataFolders.append(coreDataFolder)
            }
            }.catch { (error) in
                //
        }
    }

    public func importDiscogsItems() {

    }

}

public extension SwiftDiscogsApp.CollectionItem {

    func update(withDiscogsItem discogsItem: SwiftDiscogs.CollectionFolderItem) {
        self.rating = Int16(discogsItem.rating)
        self.releaseVersionID = Int64(discogsItem.id)

        discogsItem.notes?.forEach { (note) in

        }
    }

}

public extension SwiftDiscogsApp.CollectionItemField {

    func update(withDiscogsNote: SwiftDiscogs.CollectionFolderItem.Note) {

    }
    
}

public extension SwiftDiscogsApp.Folder {

    func update(withDiscogsFolder discogsFolder: SwiftDiscogs.CollectionFolder) {
        self.folderID = Int64(discogsFolder.id)
        self.name = discogsFolder.name
    }

}
