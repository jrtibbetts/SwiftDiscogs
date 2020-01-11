//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import JSONClient
import XCTest

class CollectionCustomFieldsTests: DiscogsTestBase {

    func testDecodeCollectionCustomFieldsJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-custom-fields-200"))
    }

    func assert(_ customFields: CollectionCustomFields,
                file: StaticString = #file,
                line: UInt = #line) {
        guard let fields = customFields.fields else {
            XCTFail("The sample custom fields response JSON should include fields.", file: file, line: line)
            return
        }

        XCTAssertEqual(fields.count, 3, file: file, line: line)

        let mediaField = fields[0]
        XCTAssertEqual(mediaField.name, "Media", "field 0's name", file: file, line: line)
        XCTAssertEqual(mediaField.type, "dropdown", "field 0's type", file: file, line: line)
        XCTAssertEqual(mediaField.`public`, true, "field 0's public flag", file: file, line: line)

        let notesField = fields[2]
        XCTAssertEqual(notesField.name, "Notes", file: file, line: line)
        XCTAssertEqual(notesField.lines!, 3, file: file, line: line)
        XCTAssertEqual(notesField.type, "textarea", file: file, line: line)
    }

}
