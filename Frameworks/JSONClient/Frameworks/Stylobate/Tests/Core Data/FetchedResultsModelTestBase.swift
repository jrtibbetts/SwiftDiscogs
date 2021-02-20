//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import Stylobate
import CoreData
import XCTest

public protocol FetchedResultsModelTestBase: ManagedObjectContextContainer {

    func model() -> FetchedResultsModel

    func testNumberOfSections()

    func testNumberOfItemsInSection()

}

public extension FetchedResultsModelTestBase {

    func testNumberOfSections() {
        // Populate the testing context.
        let person1 = Person(context: moContext!)
        person1.name = "Pondiferous Flatulence"
        person1.sortName = "Flatulence, Pondiferous"
        let person2 = Person(context: moContext!)
        person2.name = "Pancake Batter"
        person2.sortName = "Batter, Pancake"

        // Set up the fetched results controller.
        let testModel = model()
        XCTAssertEqual(testModel.numberOfSections(), 2)
        XCTAssertEqual(testModel.numberOfItems(in: 0), 1)
    }

}
