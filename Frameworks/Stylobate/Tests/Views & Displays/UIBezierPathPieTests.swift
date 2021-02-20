//  Copyright © 2019 Poikile Creations. All rights reserved.

import XCTest

class UIBezierPathPieTests: XCTestCase {

    func testInitializerOk() {
        let centerPoint = CGPoint(x: 91.0, y: 233.0)
        let radius = CGFloat(23.0)
        // Create a 90° slice that points down and left from the center.
        let slice = UIBezierPath(sliceCenter: centerPoint,
                                 radius: radius,
                                 startAngle: CGFloat.pi / 2.0,
                                 endAngle: CGFloat.pi)
        let targetPoint = CGPoint(x: 85.0, y: 239.0)
        XCTAssertTrue(slice.contains(targetPoint))
    }

}
