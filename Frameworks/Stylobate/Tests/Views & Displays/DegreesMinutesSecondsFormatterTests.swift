//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Stylobate
import CoreLocation
import XCTest

class DegreesMinutesSecondsFormatterTests: XCTestCase {

    // MARK: - DMSCoordinate

    func testDMSCoordinateAsStringOk() {
        let coord = DMSCoordinate(decimalDegrees: 40.446111)
        XCTAssertEqual(coord.asString, "40° 26' 46\"")
    }

    func testDMSCoordinateWithRoundedSecondsAsStringOk() {
        let coord = DMSCoordinate(decimalDegrees: -23.33)
        XCTAssertEqual(coord.asString, "23° 19' 48\"")
    }

    // MARK: - CLLocationCoordinate2D

    func testDegreesMinutesSecondsStringOk() {
        let coords = CLLocationCoordinate2D(latitude: 40.446111, longitude: -23.33)
        let coordStrings = coords.degreesMinutesSecondsString
        XCTAssertEqual(coordStrings.latitude, "40° 26' 46\" N")
        XCTAssertEqual(coordStrings.longitude, "23° 19' 48\" W")
    }

}
