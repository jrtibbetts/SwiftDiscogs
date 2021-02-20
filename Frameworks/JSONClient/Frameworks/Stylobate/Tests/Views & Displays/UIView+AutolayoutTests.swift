//  Copyright © 2020 Poikile Creations. All rights reserved.

import XCTest

class UIViewAutolayoutTests: XCTestCase {

    func testArrayActiveAndDeactivate() {
        let view1 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 500.0, height: 400.0))
        let view2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 150.0))
        view1.addSubview(view2)

        let constraintX = NSLayoutConstraint(item: view1,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: view2,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: 0.0)
        let constraintY = NSLayoutConstraint(item: view1,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: view2,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: 0.0)
        XCTAssertFalse(constraintX.isActive)
        XCTAssertFalse(constraintY.isActive)

        // add them to an array and activate them
        let constraints = [constraintX, constraintY]
        constraints.activate()
        XCTAssertTrue(constraintX.isActive)
        XCTAssertTrue(constraintY.isActive)

        constraints.deactivate()
        XCTAssertFalse(constraintX.isActive)
        XCTAssertFalse(constraintY.isActive)
    }

}
