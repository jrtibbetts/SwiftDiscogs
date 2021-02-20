//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreLocation

public extension CLLocationCoordinate2D {

    /// A type that contains latitude and longitude strings.
    typealias CoordinateStrings = (latitude: String, longitude: String)

    /// The *string* representations of the coordinate's latitude and longitude.
    var strings: CoordinateStrings {
        return strings()
    }

    /// Get the latitude and longitude values as *strings*, formatted according
    /// to the specified pattern.
    ///
    /// - parameter pattern: The `printf`-style pattern for formatting the
    ///                      latitude and longitude. The default is `%.2f`,
    ///                      which includes the first two decimal places.
    ///
    /// - returns: The string versions of the latitude and longitude.
    func strings(with pattern: String = "%.2f") -> CoordinateStrings {
        return (String(format: pattern, latitude),
                String(format: pattern, longitude))
    }

}
