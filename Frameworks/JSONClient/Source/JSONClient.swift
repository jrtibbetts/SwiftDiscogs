//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import OAuthSwift
import PromiseKit
import Stylobate

/// A REST client that uses OAuth authentication and gets and posts JSON data.
open class JSONClient: NSObject {
    
    public typealias Headers = [String: String]
    public typealias Parameters = [String: String]
    
    /// Errors that can be thrown by the `JSONClient`. Don't confuse the name
    /// with `Foundation.JSONError`, which are thrown by Foundation parsing
    /// calls.
    public enum JSONErr: Error {

        /// Thrown if a path contains illegal URL characters or is `nil`.
        case invalidUrl(urlString: String?)
        /// Thrown if there's no JSON data at a given path.
        case nilData
        /// Thrown if the server returned a 404 status code. (All other non-200
        /// errors should be reported with a `.serverError` case.)
        case notFound
        /// Thrown if the JSON at a given path can't be decoded into the
        /// expected type.
        case parseFailed(error: Error)
        /// Thrown if the server returned anything other than a 200 status code.
        case serverError(statusCode: Int)
        /// Thrown if the endpoint returned an HTTP 401 (unauthorized) code.
        case unauthorizedAttempt

        func rejectedPromise<T: Codable>() -> Promise<T> {
            return Promise(error: self)
        }

    }
    
    // MARK: - Properties
    
    /// The root URL for server requests.
    public let baseUrl: URL?

    public let jsonDecoder: JSONDecoder

    /// The session that will handle all REST calls.
    open var urlSession: URLSession

    // MARK: - Initializers
    
    /// Create the client.
    ///
    /// - parameter baseUrl: The URL against which all relative paths will be
    ///             resolved. If it's `nil`, then paths passed to client's
    ///             methods must be absolute ones.
    /// - parameter jsonDecoder: The decoder for JSON responses.
    public init(baseUrl: URL? = nil,
                jsonDecoder: JSONDecoder) {
        self.baseUrl = baseUrl
        self.jsonDecoder = jsonDecoder
        self.urlSession = URLSession(configuration: .default)
        super.init()
    }
    
    // MARK: - REST methods
    
    /// Get the JSON data at the specified path (relative to the `baseUrl`)
    /// and decode it to the expected type.
    ///
    /// - parameter path: The path of the URL, relative to the `baseUrl`, or,
    ///             the absolute URL if `baseUrl` is `nil`.
    /// - parameter headers: Custom header values to use in the request.
    /// - parameter parameters: Parameter name/value pairs to be appended to the
    ///             URL.
    ///
    /// - throws:   `JSONError.invalidUrl` if `path` contains illegal
    ///             characters, `JSONError.nilData` if `path` is valid,
    ///             but has no content that can be parsed,
    ///             `JSONError.parseFailed` if the JSON at `path` isn't valid
    ///             for the expected type.
    open func get<T: Codable>(path: String,
                              headers: Headers = Headers(),
                              parameters: Parameters = Parameters()) -> Promise<T> {
        return Promise<T> { (seal) in
            let urlRequest: URLRequest

            do {
                urlRequest = try request(forPath: path, headers: headers, parameters: parameters)
            } catch {
                seal.reject(error)
                return
            }

            urlSession.dataTask(with: urlRequest) { (data, response, error) in
                if self.willReject(seal: seal, ifResponse: response, hasError: error) {
                    return
                } else if data == nil {
                    /// Make sure that we got some sort of data.
                    seal.reject(JSONErr.nilData)
                } else {
                    do {
                        /// The data is non-`nil`, so parse it.
                        seal.fulfill(try self.handleSuccessfulData(data!))
                    } catch {
                        /// The data couldn't be decoded into the expected
                        /// type T.
                        seal.reject(JSONErr.parseFailed(error: error))
                    }
                }
            }.resume()  // Kick off the request. Don't forget this!
        }
    }

    // MARK: - Utility functions

    private func willReject<T>(seal: Resolver<T>,
                               ifResponse response: URLResponse?,
                               hasError error: Error?) -> Bool {
        if let error = error {
            /// Usually an "unsupported URL" NSError.
            seal.reject(error)
        } else if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200:
                return false
            case 404:
                seal.reject(JSONErr.notFound)
            default:
                seal.reject(JSONErr.serverError(statusCode: response.statusCode))
            }
        }

        return true
    }
    
    open func handleSuccessfulData<T: Codable>(_ data: Data) throws -> T {
        return try JSONUtils.jsonObject(data: data, decoder: jsonDecoder)
    }

    open func request(forPath path: String,
                      headers: Headers = Headers(),
                      parameters: Parameters = Parameters()) throws -> URLRequest {
        let initialUrl = URL(string: path, relativeTo: baseUrl)
        var components = URLComponents()
        components.queryItems = parameters.map { (key, value) -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        }

        guard let url = components.url(relativeTo: initialUrl) else {
            throw JSONErr.invalidUrl(urlString: path)
        }
        
        // Now construct the URLRequest
        var request = URLRequest(url: url)
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
}
