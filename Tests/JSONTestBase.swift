//  Copyright © 2017-2018 Poikile Creations. All rights reserved.

import JSONClient
import Stylobate
import XCTest

public class JSONTestBase: XCTestCase {

    func jsonObject<T: Codable>(inLocalJsonFileNamed fileName: String,
                                inBundle bundle: Bundle = Bundle.main) throws -> T {
        let jsonUrl = try JSONUtils.url(forFileNamed: fileName, ofType: "json",
                                        inBundle: bundle)

        return try jsonObject(fromUrl: jsonUrl)
    }

    func jsonObject<T: Codable>(fromUrl jsonUrl: URL) throws -> T {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return try JSONUtils.jsonObject(atUrl: jsonUrl, decoder: jsonDecoder)
    }

}

