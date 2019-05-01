//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
@testable import SwiftDiscogsApp
import CoreData
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
        let exp = expectation(description: "Importing")
        importer.importDiscogsCollection(forUserName: "doesn't matter").done {
            exp.fulfill()
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
