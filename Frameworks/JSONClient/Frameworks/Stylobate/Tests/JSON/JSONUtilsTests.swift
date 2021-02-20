//  Copyright © 2017-2018 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

class JSONUtilsTests: XCTestCase {

    func testJsonDataEncodeAndDecode() throws {
        let foo = Foo(optionalInt: nil, optionalString: nil, requiredInt: 999, requiredString: "Huzzah!")

        let fooData = try JSONEncoder().encode(foo)
        let otherFoo: Foo = try JSONUtils.jsonObject(data: fooData)
        XCTAssertEqual(foo, otherFoo)
    }

    func testUrlForUnknownFilenameThrows() {
        let fileName = "this file can't possibly exist"
        let fileType = "vogonPoetry"

        XCTAssertThrowsError(try JSONUtils.url(forFileNamed: fileName,
                                               ofType: fileType,
                                               inBundle: Bundle(for: type(of: self))))
    }

    func testJsonDataForLocalFile() throws {
        let foo: Foo = try JSONUtils.jsonObject(forFileNamed: "SampleFoo",
                                                ofType: "json",
                                                inBundle: StylobateTests.resourceBundle)
        XCTAssertEqual(foo.requiredInt, 99)
        XCTAssertEqual(foo.requiredString, "a required string")
    }

}
