//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class MissingCellTests: XCTestCase {

    let nib = UINib(nibName: "MissingCellTests",
                    bundle: StylobateTests.resourceBundle)

    func testMissingTableViewCellAwakeFromNibOk() throws {
        try assertMissingCell(atIndex: 0)
    }

    func testMissingCollectionViewCellAwakeFromNibOk() throws {
        try assertMissingCell(atIndex: 1)
    }

    func assertMissingCell(atIndex index: Int,
                           file: StaticString = #filePath,
                           line: UInt = #line) throws {
        guard let cell = nib.instantiate(withOwner: nil, options: nil)[index] as? MissingCell else {
            XCTFail("Expected view \(index) in the nib to be a MissingCell", file: file, line: line)
            return
        }

        XCTAssertNotNil(cell.textLabel, "text label")

        // Serialize it out and back in.
        let data = try NSKeyedArchiver.archivedData(withRootObject: cell,
                                                requiringSecureCoding: false)

        guard let copy = NSKeyedUnarchiver.unarchiveObject(with: data) as? MissingCell else {
            XCTFail("Expected a MissingCell to be deserialized", file: file, line: line)
            return
        }

        XCTAssertEqual(cell.textLabel!.text, copy.textLabel!.text, file: file, line: line)
    }

}
