//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
@testable import SwiftDiscogsApp
import CoreData
import Stylobate
import XCTest

class DiscogsCollectionImporterTests: XCTestCase {

    var importer: DiscogsCollectionImporter!

    var originalDiscogsClient: Discogs!

    override func setUp() {
        super.setUp()
        originalDiscogsClient = DiscogsManager.discogs
        DiscogsManager.discogs = MockDiscogs(errorMode: false)
        importer = DiscogsCollectionImporter(concurrencyType: .mainQueueConcurrencyType)
        importer.parent = DiscogsCollectionImporterTests.testingContext
    }

    override func tearDown() {
        DiscogsManager.discogs = originalDiscogsClient
        super.tearDown()
    }

    func testImportDiscogsCollectionWithValidUserNameOk() throws {
        let exp = expectation(description: "Importing 3 fields")
        importer.importDiscogsCollection(forUserName: "doesn't matter").done { [unowned self] in
            let fields: [CustomField] = try CustomField.all(inContext: self.importer)
            let folders: [Folder] = try Folder.all(inContext: self.importer)
            let items: [CollectionItem] = try CollectionItem.all(inContext: self.importer,
                                                                 sortedBy: [(\CollectionItem.releaseVersionID).sortDescriptor()])

            if fields.count == 3
                && folders.count == 2 && folders[0].name == "All"
                && items.count == 2 && items[0].releaseVersionID == Int64(4275843) {
                exp.fulfill()
            }
        }.cauterize()

        wait(for: [exp], timeout: 20.0)
    }

    /// An `NSManagedObjectContext` backed by an in-memory store to make it
    /// suitable for unit testing. Based on an idea by
    /// https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/
    static var testingContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: DiscogsCollectionImporter.self)])!
        let stoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        do {
            try stoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                configurationName: nil,
                                                at: nil,
                                                options: nil)
            moc.persistentStoreCoordinator = stoordinator
        } catch {
            preconditionFailure("The FetchingTestBase couldn't set up a persistent in-memory store")
        }

        return moc
    }()

}
