//  Copyright © 2019 Poikile Creations. All rights reserved.

import XCTest

class CALayerGeometryTests: XCTestCase {

    func testCenterAtPointWithNonnegativePointOk() {
        let layer = CALayer()
        layer.frame = CGRect(x: 32.0, y: 100.0, width: 420.0, height: 99.0)
        let center = CGPoint(x: 321.0, y: 411.0)
        let newFrame = layer.center(at: center)

        XCTAssertEqual(newFrame.origin.x, 111.0)
        XCTAssertEqual(newFrame.origin.y, 361.5)
    }

    func testCenterAtZeroOk() {
        let layer = CALayer()
        layer.frame = CGRect(x: 32.0, y: 100.0, width: 420.0, height: 99.0)
        let center = CGPoint(x: 0.0, y: 0.0)
        let newFrame = layer.center(at: center)

        XCTAssertEqual(newFrame.origin.x, -210.0)
        XCTAssertEqual(newFrame.origin.y, -49.5)
    }

    func testCenterInSuperLayerOk() {
        let superlayer = CALayer()
        superlayer.frame = CGRect(x: 32.0, y: 100.0, width: 420.0, height: 99.0)

        let sublayer = CALayer()
        sublayer.frame = CGRect(x: 23.0, y: 66.0, width: 23.0, height: 200.0)

        superlayer.addSublayer(sublayer)

        let newSubframe = sublayer.centerInSuperlayer()
        XCTAssertEqual(newSubframe.origin.x, 198.5)
        XCTAssertEqual(newSubframe.origin.y, -50.5)
    }

    func testCenterInSuperlayerWithNoSuperlayerReturnsOriginalFrame() {
        let layer = CALayer()
        layer.frame = CGRect(x: 32.0, y: 100.0, width: 420.0, height: 99.0)
        layer.centerInSuperlayer()

        XCTAssertEqual(layer.frame.origin.x, 32.0)
        XCTAssertEqual(layer.frame.origin.y, 100.0)
        XCTAssertEqual(layer.frame.width, 420.0)
        XCTAssertEqual(layer.frame.height, 99.0)
    }

}
