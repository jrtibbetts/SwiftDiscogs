//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import Stylobate
import CoreData
import XCTest

// swiftlint:disable force_try

class FetchingTestBase: XCTestCase, ManagedObjectContextContainer {

    // MARK: - Properties

    var moContext: NSManagedObjectContext?

    /// The core data test model. This has to be static, because if each
    /// `FetchingTestBase` subclass instantiates its own model from the same
    /// model scheme, there will be numerous warnings to the effect that
    /// "Multiple NSEntityDescriptions Claim NSManagedObject Subclass".
    static let model = NSManagedObjectModel.mergedModel(from: [StylobateTests.resourceBundle])!

    lazy var testingContainer: NSPersistentContainer! = {
        let container = NSPersistentContainer(name: "StylobateTestModel", managedObjectModel: FetchingTestBase.model)
        try! container.persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                                            configurationName: nil,
                                                                            at: nil,
                                                                            options: nil)

        return container
    }()

    var testingCoordinator: NSPersistentStoreCoordinator! {
        return testingContainer.persistentStoreCoordinator
    }

    var testingContext: NSManagedObjectContext! {
        return testingContainer.viewContext
    }

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        moContext = testingContext
    }

    // MARK: - Functions

    func importTestData() {
        (0..<14).forEach { (index) in
            let person = Person(context: testingContext!)
            person.name = "Person \(index)"
            person.sortName = "Sorted Person \(index)"
        }

        try! testingContext?.save()
    }

}

// swiftlint:enable force_try
