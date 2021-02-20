//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

// swiftlint:disable force_cast

class FormattedLabelTests: XCTestCase {

    func testSetTextWithNilFormatLeavesTextAsIs() {
        assertSetText(withInitialText: nil)
    }

    func testSetTextWithEmptyFormatIgnoresFormat() {
        assertSetText(withInitialText: "")
    }

    func testSetTextWithFormatContainingNoFormattingCharactersIgnoresFormat() {
        assertSetText(withInitialText: "This initial text has no formatting characters")
    }

    func assertSetText(withInitialText initialText: String?,
                       file: StaticString = #file,
                       line: UInt = #line) {
        let label = FormattedLabel(frame: CGRect())
        label.text = initialText
        let superview = UIView(frame: CGRect())
        superview.addSubview(label)

        let newText = "FAGABEFE"
        label.text = newText
        XCTAssertEqual(label.text, newText)
    }

    func testSetTextWithFormatOk() {
        let label = FormattedLabel(frame: CGRect())
        label.text = "'%@' is a nonsense word that's written in hex."
        let superview = UIView(frame: CGRect())
        superview.addSubview(label)

        let newText = "FAGABEFE"
        label.text = newText
        XCTAssertEqual(label.text, "'FAGABEFE' is a nonsense word that's written in hex.")
    }

    func testSetAttributedTextWithFormatLeavesAttributedTextAsIs() {
        let label = FormattedLabel(frame: CGRect())
        label.text = "'%@' is a nonsense word that's written in hex."
        let superview = UIView(frame: CGRect())
        superview.addSubview(label)

        let attributedText = NSAttributedString(string: "Inconsequential", attributes: [.backgroundColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)])
        label.attributedText = attributedText
        XCTAssertEqual(label.attributedText, attributedText)
    }

    func testSetTextWithFormatInStoryboardOk() {
        let storyboard = UIStoryboard(name: "FormattedLabelTests",
                                      bundle: StylobateTests.resourceBundle)
        let viewController = storyboard.instantiateInitialViewController()!
        let view = viewController.view as! FormattedLabelTestsView
        let label = view.labelWithFormat!

        let newText = "FAGABEFE"
        label.text = newText
        XCTAssertEqual(label.text, "Formatted as 'FAGABEFE'.")
    }
}

class FormattedLabelTestsView: UIView {

    @IBOutlet weak var labelWithFormat: FormattedLabel!

    @IBOutlet weak var labelWithoutFormat: FormattedLabel!

}

// swiftlint:enable force_cast
