//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import PromiseKit
import Stylobate

/// Base class for mock client implementations of third-party services.
open class MockClient: JSONClient {
    
    /// If `true`, each API call will pass a non-`nil` `Error` object to the
    /// completion block instead of a valid data object.
    public var errorMode: Bool = false
    
    /// The bundle that contains this implementation and the local JSON data
    /// files that is parses to return data.
    public private(set) var bundle: Bundle
    
    private let errorDomain: String

    public init(errorDomain: String? = nil,
                bundle: Bundle = Bundle.main,
                jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.errorMode = errorDomain != nil
        self.errorDomain = errorDomain ?? "The client isn't in error mode."
        self.bundle = bundle
        super.init(jsonDecoder: jsonDecoder)
    }
    
    // MARK: - Utilities
    
    public func apply<T: Codable>(toJsonObjectIn fileName: String,
                                  error: Error? = nil) -> Promise<T> {
        return Promise<T> { (seal) in
            if errorMode {
                seal.reject(error ?? NSError(domain: errorDomain, code: 0, userInfo: nil))
            } else {
                do {
                    let obj: T = try JSONUtils.jsonObject(forFileNamed: fileName,
                                                          inBundle: bundle,
                                                          decoder: jsonDecoder)
                    seal.fulfill(obj)
                } catch {
                    seal.reject(error)
                }
            }
        }
    }
    
}
