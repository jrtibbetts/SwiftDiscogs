//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class DateTrigonometryTests: XCTestCase {

    let midnight = Calendar.current.startOfDay(for: Date())

    func testNoonRotationAngleOk() {
        let noon = midnight.addingTimeInterval(12 * 60 * 60)
        XCTAssertEqual(noon.rotationAngle, (1.5 * CGFloat.pi), accuracy: 0.001)
    }

    func testMidnightRotationAngleOk() {
        XCTAssertEqual(midnight.rotationAngle, (CGFloat.pi / 2.0), accuracy: 0.001)
    }

    func test6amRotationAngleOk() {
        let sixAm = midnight.addingTimeInterval(6 * 60 * 60)
        XCTAssertEqual(sixAm.rotationAngle, CGFloat.pi, accuracy: 0.001)
    }

    func test6pmRotationAngleOk() {
        let sixPm = midnight.addingTimeInterval(18 * 60 * 60)
        XCTAssertEqual(sixPm.rotationAngle, 2.0 * CGFloat.pi, accuracy: 0.001)
    }

}
