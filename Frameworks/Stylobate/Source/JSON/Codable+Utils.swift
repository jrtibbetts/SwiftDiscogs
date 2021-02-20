//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public extension Decodable {

    static func decode<T: Decodable>(fromJSONData jsonData: Data,
                                     withDecoder decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: jsonData)
    }

    static func decode<T: Decodable>(fromJSONFileNamed jsonFilename: String,
                                     inBundle bundle: Bundle = Bundle.main,
                                     withDecoder decoder: JSONDecoder = JSONDecoder()) throws -> T? {
        if let jsonURL = bundle.url(forResource: jsonFilename, withExtension: "json") {
            return try decode(fromURL: jsonURL, withDecoder: decoder)
        } else {
            return nil
        }
    }

    static func decode<T: Decodable>(fromJSONString jsonString: String,
                                     withDecoder decoder: JSONDecoder = JSONDecoder()) throws -> T? {
        if let jsonData = jsonString.data(using: .utf8) {
            return try decode(fromJSONData: jsonData, withDecoder: decoder)
        } else {
            return nil
        }
    }

    static func decode<T: Decodable>(fromURL url: URL,
                                     withDecoder decoder: JSONDecoder = JSONDecoder()) throws -> T {
        let data = try Data(contentsOf: url)
        return try decode(fromJSONData: data, withDecoder: decoder)
    }

}

public extension Encodable {

    func jsonString(usingEncoder encoder: JSONEncoder = JSONEncoder()) throws -> String? {
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }

}
