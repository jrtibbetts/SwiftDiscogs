//  Copyright © 2017 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
import JSONClient
import XCTest

class DiscogsTestBase: ClientTestBase {

    func discogsObject<T: Codable>(inLocalJsonFileNamed fileName: String) throws -> T {
        let bundle = Bundle(for: MockDiscogs.self)

        do {
            return try jsonObject(inLocalJsonFileNamed: fileName, inBundle: bundle)
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case let .keyNotFound(key, _):
                    print("Key not found: \(key)")
                default:
                    break
                }
            }

            print("Caught error while parsing \(fileName): \(error.localizedDescription)")
            throw error
        }
    }

    func assertDiscogsErrorMessage(in jsonFilename: String,
                                   is expectedString: String) {
        do {
            let discogsError: DiscogsErrorResponse = try discogsObject(inLocalJsonFileNamed: jsonFilename)
            XCTAssertEqual(discogsError.message, expectedString)
        } catch {
            XCTFail("Failed to assert the error message; got \"\(error.localizedDescription)\" instead.")
        }
    }
    
}
