//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogsApp
import XCTest

class ControllerTestBase: XCTestCase {

    var viewController: Controller?
    
    var display: Display? {
        return viewController?.display
    }

    var model: Model? {
        return viewController?.model
    }
    
}
