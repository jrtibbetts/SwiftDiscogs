//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class ToggleStackViewTests: XCTestCase {

    let stack10 = ToggleStackView() <~ {
        let stack = $0
        (1..<10).forEach { (_) in
            let subview = UIView()
            subview.isHidden = false
            stack.addArrangedSubview(subview)
        }
    }

    func testSetActiveViewHidesAllOtherSubviews() {
        let stack = stack10
        let activeSubview = UIView()
        stack.addArrangedSubview(activeSubview)

        stack.activeView = activeSubview

        stack.arrangedSubviews.forEach { (subview) in
            if subview != activeSubview {
                XCTAssertTrue(subview.isHidden)
            } else {
                XCTAssertFalse(subview.isHidden)
            }
        }
    }

    func testSetActiveViewToNilUnhidesAllSubviews() {
        let stack = stack10
        let activeSubview = UIView()
        stack.addArrangedSubview(activeSubview)

        stack.activeView = activeSubview
        stack.activeView = nil

        stack.arrangedSubviews.forEach { (subview) in
            XCTAssertFalse(subview.isHidden)
        }
    }

    func testAddArrangedSubviewToEmptyStackMakesSubviewTheActiveView() {
        let stack = ToggleStackView()
        XCTAssertNil(stack.activeView)
        XCTAssertNil(stack.previousActiveView)

        let subview = UIView()
        stack.addArrangedSubview(subview)
        XCTAssertEqual(subview, stack.activeView)
        XCTAssertFalse(subview.isHidden)
        XCTAssertNil(stack.previousActiveView)
    }

    func testAddHiddenArrangedSubviewToEmptyStackMakesSubviewTheActiveView() {
        let stack = ToggleStackView()
        XCTAssertNil(stack.activeView)

        let subview = UIView()
        subview.isHidden = true
        stack.addArrangedSubview(subview)
        XCTAssertEqual(subview, stack.activeView)
        XCTAssertFalse(subview.isHidden)
    }

    func testRemoveArrangedViewMakesFirstArrangedViewTheActiveView() {
        let stack = stack10
        let activeSubview = UIView()
        stack.addArrangedSubview(activeSubview)

        stack.activeView = activeSubview
        stack.removeArrangedSubview(activeSubview)

        stack.arrangedSubviews.enumerated().forEach { (index, subview) in
            if index == 0 {
                XCTAssertEqual(stack.activeView, subview)
                XCTAssertFalse(subview.isHidden)
            } else {
                XCTAssertTrue(subview.isHidden)
            }
        }
    }

    func testRemoveArrangedViewReactivatesPreviousActiveView() {
        let stack = stack10

        let fourthSubview = stack.arrangedSubviews[3]
        stack.activeView = fourthSubview
        XCTAssertEqual(stack.activeView, fourthSubview)

        let eighthSubview = stack.arrangedSubviews[7]
        stack.activeView = eighthSubview
        XCTAssertEqual(stack.activeView, eighthSubview)
        XCTAssertEqual(stack.previousActiveView, fourthSubview)
    }

    func testRemoveInactiveArrangedViewLeaveArrangedViewAsIs() {
        let stack = stack10

        let activeSubview = UIView()
        stack.addArrangedSubview(activeSubview)
        stack.activeView = activeSubview

        let firstSubview = stack.arrangedSubviews.first!
        stack.removeArrangedSubview(firstSubview)

        XCTAssertEqual(stack.activeView, activeSubview)
    }

}
