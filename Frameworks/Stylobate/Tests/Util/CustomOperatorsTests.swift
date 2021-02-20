//  Copyright © 2017 nrith. All rights reserved.

@testable import Stylobate
import UIKit
import XCTest

// swiftlint:disable force_try

class CustomOperatorsTests: XCTestCase {

    // MARK: - <~
    func testBlockAssignment() {
        let text = "This is the label's text"
        let font = UIFont.boldSystemFont(ofSize: 93.0)
        let textColor = UIColor.cyan

        let label = UILabel() <~ {
            $0.text = text
            $0.font = font
            $0.textColor = textColor
        }

        XCTAssertEqual(label.text, text)
        XCTAssertEqual(label.font, font)
        XCTAssertEqual(label.textColor, textColor)
    }

    // MARK: - =~

    func testRegexMatchesPartialString() {
        let string = "This is the string to be searched."
        let pattern = "the string"
        XCTAssertTrue(try! string =~ pattern)
    }

    func testRegexDoesntMatchString() {
        let string = "This is the string to be searched."
        let pattern = "All good boys deserve favor."
        XCTAssertFalse(try! string =~ pattern)
    }

    func testRegexMatchesEntireString() {
        let string = "This is the string to be searched"
        let pattern = string
        XCTAssertTrue(try! string =~ pattern)
    }

}

// swiftlint:enable force_try
