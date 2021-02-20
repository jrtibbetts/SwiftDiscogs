//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class VisualIndicatorBusyViewTests: XCTestCase {

    func testStartActivityWithNilCompletionOk() {
        let view = TestableBusyView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0))
        XCTAssertNotNil(view.busyIndicator)
        XCTAssertTrue(view.subviews.first === view.busyIndicator)
        XCTAssertFalse(view.subviews.last === view.busyIndicator)

        view.startActivity()
        XCTAssertNotNil(view.busyIndicator)
        XCTAssertFalse(view.subviews.first === view.busyIndicator)
        XCTAssertTrue(view.subviews.last === view.busyIndicator)
   }

    func testStopActivityWithNilCompletionOk() {
        let view = TestableBusyView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0))
        XCTAssertNotNil(view.busyIndicator)
        XCTAssertTrue(view.subviews.first === view.busyIndicator)
        XCTAssertFalse(view.subviews.last === view.busyIndicator)

        view.startActivity()
        XCTAssertNotNil(view.busyIndicator)
        XCTAssertFalse(view.subviews.first === view.busyIndicator)
        XCTAssertTrue(view.subviews.last === view.busyIndicator)

        view.stopActivity()
        XCTAssertNotNil(view.busyIndicator)
        XCTAssertTrue(view.subviews.first === view.busyIndicator)
        XCTAssertFalse(view.subviews.last === view.busyIndicator)
    }

    class TestableBusyView: UIView, VisualIndicatorBusyView {

        lazy var busyIndicator: UIView? = {
            let indicator = UILabel(frame: CGRect())
            indicator.text = "This is the busy indicator."

            return indicator
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            initializeUI()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initializeUI()
        }

        func initializeUI() {
            addSubview(busyIndicator!)

            let redView = UIView(frame: self.frame)
            redView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            addSubview(redView)
        }
    }

}
