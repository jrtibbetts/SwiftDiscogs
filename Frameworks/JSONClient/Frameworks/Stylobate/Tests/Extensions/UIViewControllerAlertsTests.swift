//  Copyright © 2018 Poikile Creations. All rights reserved.

import XCTest

class UIViewControllerAlertsTests: XCTestCase {

    func testPresentAlertWithNoMessageOk() {
        let error = NSError(domain: "StylobateTests", code: 0, userInfo: nil)
        let message: String? = nil
        let viewController = UIViewController()
        viewController.presentAlert(for: error, title: message)
    }

}
