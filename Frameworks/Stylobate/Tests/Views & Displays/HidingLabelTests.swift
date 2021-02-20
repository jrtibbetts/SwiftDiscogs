//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class HidingLabelTests: XCTestCase {

    // MARK: - text tests

    func testHidingLabelWithNonNilTextIsNotHidden() {
        let label = HidingLabel(frame: .zero)
        label.text = "some non-nil string"
        XCTAssertFalse(label.isHidden)
    }

    func testHidingLabelWithNilTextIsHidden() {
        let label = HidingLabel(frame: .zero)
        label.text = nil
        XCTAssertTrue(label.isHidden)
    }

    func testHidingLabelWithEmptyTextIsHidden() {
        let label = HidingLabel(frame: .zero)
        label.text = ""
        XCTAssertTrue(label.isHidden)
    }

    // MARK: - attributedText tests

    func testHidingLabelWithNonNilAttributedTextIsNotHidden() {
        let label = HidingLabel(frame: .zero)
        label.attributedText = NSAttributedString(string: "some non-nil string")
        XCTAssertFalse(label.isHidden)
    }

    func testHidingLabelWithNilAttributedTextIsHidden() {
        let label = HidingLabel(frame: .zero)
        label.attributedText = nil
        XCTAssertTrue(label.isHidden)
    }

    func testHidingLabelWithEmptyAttributedTextIsHidden() {
        let label = HidingLabel(frame: .zero)
        label.attributedText = NSAttributedString(string: "")
        XCTAssertTrue(label.isHidden)
    }

    // MARK: - combination tests

    func testHidingLabelWithNonNilTextAndNilAttributedTextIsNotHidden() {
        let label = HidingLabel(frame: .zero)
        label.attributedText = nil
        label.text = "some non-nil string"
        XCTAssertFalse(label.isHidden)
    }

    func testHidingLabelWithOneNilPropertyIsHiddenWhenPropertyIsAssignedLast() {
        let label = HidingLabel(frame: .zero)
        label.text = "some non-nil string"
        label.attributedText = nil
        XCTAssertTrue(label.isHidden)
    }

}
