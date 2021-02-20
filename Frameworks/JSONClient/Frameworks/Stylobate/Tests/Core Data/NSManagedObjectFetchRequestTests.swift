//  Copyright © 2019 Poikile Creations. All rights reserved.

import XCTest

class NSManagedObjectFetchRequestTests: FetchingTestBase {

    func testAll() throws {
        importTestData()
        let allPeople: [Person] = try Person.all(inContext: testingContext)
        XCTAssertEqual(allPeople.count, 14)
    }

}
