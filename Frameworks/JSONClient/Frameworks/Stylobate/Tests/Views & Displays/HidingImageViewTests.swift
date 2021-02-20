//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class HidingImageViewTests: XCTestCase {

    func testImageViewIsHiddenIfImageIsNil() {
        let view = HidingImageView(frame: .zero)
        XCTAssertFalse(view.isHidden)
        view.image = nil
        XCTAssertTrue(view.isHidden)
    }

}
