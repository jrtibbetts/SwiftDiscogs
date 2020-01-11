//  Copyright © 2017-2018 Poikile Creations. All rights reserved.

import PromiseKit
import XCTest

class ClientTestBase: JSONTestBase {

    var timeoutSeconds: TimeInterval = 5.0

    @discardableResult
    func assert<T>(validPromise promise: Promise<T>,
                   description: String = "valid \(type(of: T.self))",
                   file: StaticString = #file,
                   line: UInt = #line) -> T? {
        let exp = expectation(description: description)
        var returnableObject: T?

        promise.done { (fetchedObject) in
            returnableObject = fetchedObject
            exp.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription, file: file, line: line)
        }

        wait(for: [exp], timeout: timeoutSeconds)

        return returnableObject
    }

    @discardableResult
    func assert<T>(invalidPromise promise: Promise<T>,
                   description: String = "invalid \(type(of: T.self))",
                   file: StaticString = #file,
                   line: UInt = #line) -> Error? {
        let exp = expectation(description: description)
        var returnableError: Error?

        promise.done { _ in
            XCTFail("Expected an error to be thrown.", file: file, line: line)
        }.catch { (error) -> Void in
            returnableError = error
            exp.fulfill()
        }

        wait(for: [exp], timeout: timeoutSeconds)

        return returnableError
    }

}
