//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

public extension CALayer {

    /// Move the layer so that its center is at the specified point.
    ///
    /// - parameter centerPoint: The new center point.
    ///
    /// - returns: The layer's new `frame`.
    @discardableResult func center(at centerPoint: CGPoint) -> CGRect {
        let newOriginX = centerPoint.x - (bounds.width / 2.0)
        let newOriginY = centerPoint.y - (bounds.height / 2.0)
        let newOrigin = CGPoint(x: newOriginX, y: newOriginY)

        frame = CGRect(origin: newOrigin, size: bounds.size)

        return frame
    }

    /// Move the layer so that it's centered in the superlayer's bounds.
    ///
    /// - returns: The layer's new `frame`.
    @discardableResult func centerInSuperlayer() -> CGRect {
        guard let superlayer = superlayer else {
            return frame
        }

        return center(at: superlayer.frame.center)
    }

}

public extension CGRect {

    /// Get the point at the center of the rectangle. Why doesn't this exist
    /// already?
    var center: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }

}
