//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

// swiftlint:disable force_cast

class ToggleButtonStackViewTests: XCTestCase {

    func testSetActiveViewOnEmptyStackDoesNothing() {
        let stack = ToggleButtonStackView(frame: .zero)
        let unattachedButton = UIButton(frame: .zero)
        stack.activeView = unattachedButton
        XCTAssertTrue(stack.arrangedSubviews.isEmpty)
    }

    func testSetActiveViewOnNonEmptyStackSetsSelectsTheButton() {
        let stack = ToggleButtonStackView(frame: .zero)

        (0..<5).forEach { (index) in
            let button = UIButton(frame: .zero)
            button.setTitle("\(index)", for: [])
            stack.addArrangedSubview(button)
        }

        let selectedButton = stack.arrangedSubviews[2]
        stack.activeView = selectedButton

        XCTAssertFalse((stack.arrangedSubviews[0] as! UIButton).isSelected)
        XCTAssertFalse((stack.arrangedSubviews[1] as! UIButton).isSelected)
        XCTAssertTrue((stack.arrangedSubviews[2] as! UIButton).isSelected)
        XCTAssertFalse((stack.arrangedSubviews[3] as! UIButton).isSelected)
        XCTAssertFalse((stack.arrangedSubviews[4] as! UIButton).isSelected)
    }

    func testSetActiveViewToNilOnNonEmptyStackDeselectsAllButtons() {
        let stack = ToggleButtonStackView(frame: .zero)

        (0..<5).forEach { (index) in
            let button = UIButton(frame: .zero)
            button.setTitle("\(index)", for: [])
            stack.addArrangedSubview(button)
        }

        let selectedButton = stack.arrangedSubviews[2]
        stack.activeView = selectedButton
        stack.activeView = nil

        stack.arrangedSubviews.forEach { (button) in
            XCTAssertFalse((button as! UIButton).isSelected)
        }
    }

}

// swiftlint:enable force_cast
