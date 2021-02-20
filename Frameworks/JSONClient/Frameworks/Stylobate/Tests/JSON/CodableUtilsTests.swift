//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import XCTest

// swiftlint:disable force_try

private let completeFooString = """
{
    "optionalInt": 9,
    "requiredInt": 99,
    "optionalString": "an optional string",
    "requiredString": "a required string"
}
"""

class CodableUtilsTests: XCTestCase {

    func testDecodeFromStringWithAllRequiredValues() {
        let foo: Foo = try! Foo.decode(fromJSONString: completeFooString)!
        XCTAssertEqual(foo.requiredInt, 99)
        XCTAssertEqual(foo.requiredString, "a required string")
    }

    func testDecodeFromMalformedStringThrows() {
        let fooString = """
"""
        do {
            if let _: Foo = try Foo.decode(fromJSONString: fooString) {
                XCTFail("A malformed JSON string shouldn't be parsable.")
            } else {
                XCTFail("A malformed JSON string shouldn't even get this far.")
            }
        } catch {

        }
    }

    func testDecodeFromFile() {
        // When running unit tests, Bundle.main is the Simulator's bundle, not
        // the testing bundle.
        let bundle = StylobateTests.resourceBundle
        let foo: Foo = try! Foo.decode(fromJSONFileNamed: "SampleFoo", inBundle: bundle)!
        XCTAssertEqual(foo.requiredInt, 99)
        XCTAssertEqual(foo.requiredString, "a required string")
    }

    func testDecodeFromMissingFileReturnsNil() {
        // When running unit tests, Bundle.main is the Simulator's bundle, not
        // the testing bundle.
        let bundle = Bundle(for: type(of: self))
        let foo: Foo? = try! Foo.decode(fromJSONFileNamed: "A file that doesn't exist", inBundle: bundle)
        XCTAssertNil(foo)
    }

    func testPerformanceOfDecodeFromStringWithDefaultDecoder() {
        // This is an example of a performance test case.
        self.measure {
            10000.times { _ in
                let _: Foo = try! Foo.decode(fromJSONString: completeFooString)!
            }
        }
    }

    func testPerformanceOfDecodeFromStringWithSpecificDecoder() {
        let decoder = JSONDecoder()

        // This is an example of a performance test case.
        self.measure {
            10000.times { _ in
                let _: Foo = try! Foo.decode(fromJSONString: completeFooString,
                                             withDecoder: decoder)!
            }
        }
    }

    func testJsonString() throws {
        let bundle = StylobateTests.resourceBundle
        let firstFoo: Foo = try Foo.decode(fromJSONFileNamed: "SampleFoo", inBundle: bundle)!

        // Create a JSON string
        let encoder = JSONEncoder()
        let jsonString = try firstFoo.jsonString(usingEncoder: encoder)!

        let secondFoo: Foo = try Foo.decode(fromJSONString: jsonString)!
        XCTAssertEqual(firstFoo.requiredString, secondFoo.requiredString)
    }

}

// swiftlint:enable force_try
