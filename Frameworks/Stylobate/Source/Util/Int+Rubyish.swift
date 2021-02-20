//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public extension Int {

    /// Get a range from 0 to `self`, unless `self` is negative, in which case
    /// the range is empty. This is inspired by Ruby's `Numeric.times` function.
    /// Call it like `30.times.map { (number) ... }`.
    var times: Range<Int> {
        if self < 0 {
            return (0..<0)
        } else {
            return (0..<self)
        }
    }

    /// Call a block `self` number of times. If `self` is negative, then
    /// `block` will never be called.
    ///
    /// - parameter block: A block that's called repeatedly. It takes a single
    ///             argument, which is the *n*th time the block is being
    ///             called, from `0` to `(self - 1)`, inclusive.
    func times(block: (Int) -> Void) {
        times.forEach { block($0) }
    }

}
