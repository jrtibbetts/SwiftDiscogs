//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class NSPredicateOperatorsTests: XCTestCase {

    func testAnd2PredicatesOk() {
        let predicate1 = NSPredicate(format: "something = \"something else\"")
        let predicate2 = NSPredicate(format: "anotherThing = \"another thing\"")
        let compoundPredicate = predicate1 + predicate2
        XCTAssertEqual(compoundPredicate.subpredicates.count, 2)
        XCTAssertEqual(compoundPredicate.compoundPredicateType, .and)
    }

}
