//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import CoreLocation
import XCTest

class CLLocationCoordinate2DFormattingTests: XCTestCase {

    func testFormattedWithFloatPatternRoundsOk() {
        let coordinate = CLLocationCoordinate2D(latitude: -45.12345, longitude: 125.12345)
        let strings = coordinate.strings(with: "%.4f")
        XCTAssertEqual(strings.latitude, "-45.1234")  // why not "-45.1235"?
        XCTAssertEqual(strings.longitude, "125.1235")
    }

    func testStringsOk() {
        let coordinate = CLLocationCoordinate2D(latitude: -45.12345, longitude: 125.12345)
        let strings = coordinate.strings
        XCTAssertEqual(strings.latitude, "-45.12")
        XCTAssertEqual(strings.longitude, "125.12")
    }

    func testStringsRoundsOk() {
        let coordinate = CLLocationCoordinate2D(latitude: -45.12987, longitude: 125.12987)
        let strings = coordinate.strings
        XCTAssertEqual(strings.latitude, "-45.13")
        XCTAssertEqual(strings.longitude, "125.13")
    }

}
