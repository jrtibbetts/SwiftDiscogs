//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class IntRubyishTests: XCTestCase {

    // MARK: - times (property)

    func testTimesPropertyWhenSelfIsNegativeReturnsEmptyRange() {
        let range = (-898).times
        XCTAssertEqual(range.lowerBound, 0)
        XCTAssertEqual(range.upperBound, 0)
    }

    func testTimesPropertyWhenSelfIsZeroReturnsEmptyRange() {
        let range = 0.times
        XCTAssertEqual(range.lowerBound, 0)
        XCTAssertEqual(range.upperBound, 0)
    }

    func testTimesPropertyWhenSelfIsPositiveReturnsExpectedRange() {
        let value = 1564
        let range = value.times
        XCTAssertEqual(range.lowerBound, 0)
        XCTAssertEqual(range.upperBound, value)
    }

    // MARK: - times()

    func testTimesFunctionWhenSelfIsNegativeNeverRunsTheBlock() {
        (-898).times { _ in
            XCTFail("This block should never be executed because the range is empty.")
        }
    }

    func testTimesFunctionWhenSelfIsZeroNeverRunsTheBlock() {
        (0).times { _ in
            XCTFail("This block should never be executed because the range is empty.")
        }
    }

    func testTimesFunctionWhenSelfIsPositiveRunsTheBlockThatManyTimes() {
        var numberOfBlockExecutions = 0

        1564.times { _ in
            numberOfBlockExecutions += 1
        }

        XCTAssertEqual(numberOfBlockExecutions, 1564)
    }

}
