//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import CoreGraphics

internal extension Date {

    /// The angle, in radians, of the `Date`, relative to 12:00 am the same day.
    var rotationAngle: CGFloat {
        let midnight = Calendar.current.startOfDay(for: self)
        let timeInMinutes = timeIntervalSince(midnight) / 60
        let percentage = timeInMinutes / 1440.0

        return (CGFloat.pi / 2.0) + (CGFloat.pi * 2 * CGFloat(percentage))
    }

}
