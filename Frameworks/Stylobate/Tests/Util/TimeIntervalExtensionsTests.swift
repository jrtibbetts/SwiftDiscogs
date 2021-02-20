//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class TimeIntervalExtensionsTests: XCTestCase {

    func test14DaysIs2Weeks() {
        XCTAssertEqual(14.days, 2.weeks)
    }

    func test2YearsIs104WeeksAndTwoDays() {
        XCTAssertEqual(2.years, 104.weeks + 2.days)
    }

}
