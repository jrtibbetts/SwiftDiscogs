//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import XCTest

class ImportStatusViewTests: XCTestCase {

    var statusView: ImportStatusView!

    override func setUp() {
        let nib = UINib(nibName: "ImportStatusView", bundle: Bundle.main)
        let views = nib.instantiate(withOwner: self, options: nil)

        statusView = views.first as? ImportStatusView
    }

    func testInitialState() {
        statusView.stopImporting()
        XCTAssertTrue(statusView.statusStack.isHidden)
        XCTAssertTrue(statusView.spinner.isHidden)
        XCTAssertFalse(statusView.spinner.isAnimating)
        XCTAssertEqual(statusView.statusLabel.text, "")
        XCTAssertEqual(statusView.importButton.title(for: .normal), "Import")
    }

    func testImportingState() {
        statusView.startImporting()
        XCTAssertFalse(statusView.statusStack.isHidden)
        XCTAssertFalse(statusView.spinner.isHidden)
        XCTAssertTrue(statusView.spinner.isAnimating)
        XCTAssertEqual(statusView.statusLabel.text, "Importing")
        XCTAssertEqual(statusView.importButton.title(for: .normal), "Stop")
    }

}
