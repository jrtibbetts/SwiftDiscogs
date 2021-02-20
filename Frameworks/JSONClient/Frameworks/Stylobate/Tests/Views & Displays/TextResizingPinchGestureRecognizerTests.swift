//  Copyright © 2020 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class TextResizingPinchGestureRecognizerTests: XCTestCase {

    var gesture: TextResizingPinchGestureRecognizer!

    var pinchEnded = false
    var textView: UITextView!

    override func setUp() {
        pinchEnded = false
        textView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 400.0))
        gesture = TextResizingPinchGestureRecognizer(textView: textView,
                                                     pinchEnded: gestureHandler)
    }

    override func tearDown() {
    }

    func testMockPinch() {
        XCTAssertFalse(gesture.inProgress)
        XCTAssertFalse(pinchEnded)
        XCTAssertTrue(textView.gestureRecognizers!.contains(gesture))
    }

    func gestureHandler(_ gesture: TextResizingPinchGestureRecognizer) {
        pinchEnded = true
    }

}
