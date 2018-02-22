//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftDiscogs
import JSONClient
import XCTest

class DiscogsTestBase: ClientTestBase {

    func discogsObject<T: Codable>(inLocalJsonFileNamed fileName: String) throws -> T {
        let bundle = Bundle(for: MockDiscogs.self)
        
        return try jsonObject(inLocalJsonFileNamed: fileName, inBundle: bundle)
    }

    func assertDiscogsErrorMessage(in jsonFilename: String,
                                   is expectedString: String) {
        do {
            let discogsError: DiscogsErrorResponse = try discogsObject(inLocalJsonFileNamed: jsonFilename)
            XCTAssertEqual(discogsError.message, expectedString)
        } catch {
            XCTFail("Failed to assert the error message; got \(error.localizedDescription) instead.")
        }
    }
    
}
