//  Copyright © 2017-2018 Poikile Creations. All rights reserved.

import Foundation

/// Types for JSON encoding and decoding errors.
public enum JSONFileLoadingError: Error {

    /// Thrown when no file of the specified name and extension was found in
    /// a bundle.
    case fileNotFound(fileName: String, type: String, bundle: Bundle)
}

/// A collection of static utility functions for encoding and decoding JSON
/// data.
public struct JSONUtils {

    // MARK: - Decoding functions

    /// Decode JSON data. This is really just a shortcut that calls
    /// `JSONDecoder.decode(_:data)` without specifying the target type, which
    /// can be inferred from the return type.
    ///
    /// - parameter data: The JSON data.
    ///
    /// - throws:   Errors if no valid `Data` was found at the specified `URL`,
    ///             or if the data couldn't be decoded into a valid object.
    ///
    /// - returns:  The `Codable` object parsed from the JSON data.
    public static func jsonObject<T: Decodable>(data: Data,
                                                decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try T.decode(fromJSONData: data, withDecoder: decoder)
    }

    /// Decode the JSON data at a specified URL.
    ///
    /// - parameter atUrl: The `URL` of the JSON data.
    ///
    /// - throws:   Errors if no valid `Data` was found at the specified `URL`,
    ///             or if the data couldn't be decoded into a valid object.
    ///
    /// - returns:  The `Codable` object parsed from the JSON data.
    public static func jsonObject<T: Decodable>(atUrl jsonUrl: URL,
                                                decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try T.decode(fromURL: jsonUrl, withDecoder: decoder)
    }

    /// Decode the JSON data in a specified local file.
    ///
    /// - parameter atUrl: The `URL` of the JSON data.
    /// - parameter forFileNamed: The name of the file, *without* an extension.
    /// - parameter ofType: The extension of the file. The default is `json`.
    /// - parameter inBundle: The resource bundle in which the file is found.
    ///             The default is `Bundle.main`.
    ///
    /// - returns:  The `Codable` object parsed from the JSON data.
    public static func jsonObject<T: Decodable>(forFileNamed fileName: String,
                                                ofType fileType: String = "json",
                                                inBundle bundle: Bundle = Bundle.main,
                                                decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try jsonObject(atUrl: url(forFileNamed: fileName, ofType: fileType, inBundle: bundle),
                              decoder: decoder)
    }

    /// Get a local URL for a file of a specified type in a bundle.
    ///
    /// - parameter forFileNamed: The name of the file, *without* an extension.
    /// - parameter ofType: The extension of the file. The default is `json`.
    /// - parameter inBundle: The resource bundle in which the file is found.
    ///             The default is `Bundle.main`.
    ///
    /// - throws:   `JSONFileLoadingError.fileNotFound` if the specified file
    ///             isn't in the specified bundle.
    ///
    /// - returns:  A `URL` for the specified local file.
    public static func url(forFileNamed fileName: String,
                           ofType fileType: String = "json",
                           inBundle bundle: Bundle = Bundle.main) throws -> URL {
        guard let jsonFilePath = bundle.path(forResource: fileName, ofType: fileType) else {
            throw JSONFileLoadingError.fileNotFound(fileName: fileName, type: fileType, bundle: bundle)
        }

        return URL(fileURLWithPath: jsonFilePath)
    }

}
