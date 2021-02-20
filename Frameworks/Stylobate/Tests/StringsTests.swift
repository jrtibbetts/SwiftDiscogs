//  Copyright © 2020 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class StringsTests: XCTestCase {

    func testFontSizeString() {
        let fontSizeString = L10n.fontSizeButtonTitle("20")
        XCTAssertEqual(fontSizeString, "20 pt")
    }

}
