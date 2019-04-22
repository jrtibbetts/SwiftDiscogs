//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import JSONClient
import XCTest

class CollectionCustomFieldsTests: DiscogsTestBase {
    
    func testDecodeCollectionCustomFieldsJson() throws {
        assert(try discogsObject(inLocalJsonFileNamed: "get-custom-fields-200"))
    }
    
    fileprivate func assert(_ customFields: CollectionCustomFields) {
        guard let fields = customFields.fields else {
            XCTFail("The sample custom fields response JSON should include fields.")
            return
        }
        
        XCTAssertEqual(fields.count, 3)
        
        let mediaField = fields[0]
        XCTAssertEqual(mediaField.name, "Media", "field 0's name")
        XCTAssertEqual(mediaField.type, "dropdown", "field 0's type")
        XCTAssertEqual(mediaField.`public`, true, "field 0's public flag")
        
        let notesField = fields[2]
        XCTAssertEqual(notesField.name, "Notes")
        XCTAssertEqual(notesField.lines!, 3)
        XCTAssertEqual(notesField.type, "textarea")
    }
    
}
