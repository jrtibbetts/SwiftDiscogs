//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation

/// Represents a decimal latitude or longitude coordinate as a
/// Degree-Minute-Second (DMV) tuple of `Int`s, or as a string.
/// See
/// https://stackoverflow.com/questions/35120793/convert-mapkit-latitude-and-longitude-to-dms-format/35120978#35120978
public struct DMSCoordinate: Codable {

    /// Get a Degrees-Minutes-Seconds string representation of the coordinate,
    /// e.g. 34° 23' 54". The cardinal direction is **not** included, because
    /// the coordinate doesn't know whether it's latitude or longitude. Use
    /// `CLLocationCoordinate2D.degreesMinutesSecondsString(latitude:longitude:)`
    /// instead.
    var asString: String {
        return String(format: "\(degrees)° \(minutes)' \(seconds)\"", seconds)
    }

    /// The integer value of the decimal degree, rounded down.
    public var degrees: Int {
        return abs(Int(decimalDegrees)) // == floor(self)
    }

    /// The minutes of the decimal degree, expressed as a number from 0 to 60,
    /// rounded to the nearest whole number.
    public var minutes: Int {
        // swiftlint:disable identifier_name
        let x = (decimalDegrees * 3600.0)
        let y = x.truncatingRemainder(dividingBy: 3600.0).rounded()
        let z = y / 60.0
        // swiftlint:enable identifier_name

        return abs(Int(z))
    }

    /// The seconds of the decimal degree, expressed as a number from 0 to 60,
    /// rounded to the nearest whole number.
    public var seconds: Int {
        // swiftlint:disable identifier_name
        let x = (decimalDegrees * 3600.0)
        let y = x.truncatingRemainder(dividingBy: 3600.0)
        let z = y.truncatingRemainder(dividingBy: 60.0).rounded()
        // swiftlint:enable identifier_name

        return abs(Int(z))
    }

    // MARK: - Private Properties

    fileprivate let decimalDegrees: Double

    // MARK: - Initialization

    public init(decimalDegrees: Double) {
        self.decimalDegrees = decimalDegrees
    }

}

extension CLLocationCoordinate2D {

    /// The raw Degrees-Minutes-Seconds representations of a latitude/longitude
    /// pair. Note that neither one has any cardinality indicated, so it's up
    /// to the caller to determine north, south, east, and west manually by
    /// checking the sign of the latitude and longitude decimal value.
    var degreesMinutesSeconds: (latitude: DMSCoordinate, longitude: DMSCoordinate) {
        let lat = DMSCoordinate(decimalDegrees: self.latitude)
        let lon = DMSCoordinate(decimalDegrees: self.longitude)

        return (lat, lon)
    }

    /// The latitude and longitude strings. The cardinal directions (e.g. `N`,
    /// `E`, `W`, `S`) are **not** localized yet.
    var degreesMinutesSecondsString: (latitude: String, longitude: String) {
        let dms = degreesMinutesSeconds
        return ("\(dms.latitude.asString) " + (latitude >= 0 ? "N" : "S"),
                "\(dms.longitude.asString) " + (longitude >= 0 ? "E" : "W"))
    }

}
