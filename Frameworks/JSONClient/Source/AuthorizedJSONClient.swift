//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import OAuthSwift
import PromiseKit
import Stylobate

/// A JSON client that can be authenticated against a server and make
/// authorized REST calls for restricted resources.
open class AuthorizedJSONClient: JSONClient {

    // MARK: - Public Properties

    /// The defaults object where the client's OAuth credential will be stored.

    open var defaults: UserDefaults = UserDefaults.standard

    open var isSignedIn: Bool {
        if let credential = oAuthCredential {
            return !credential.isTokenExpired()
        } else {
            return false
        }
    }

    /// The OAuth authentication mode that the client will use for
    /// authorization. This will be either `OAuth1Swift` or `OAuth2Swift`.
    var oAuth: OAuthSwift

    /// The client that handles OAuth authorization and inserts the relevant
    /// headers in calls to the server. Subclasses should assign a value to
    /// this once the user successfully authenticates with the server.
    var oAuthClient: OAuthSwiftClient?

    // MARK: Internal Properties

    /// The service's endpoint for initiating an authorization sequence. This
    /// is used internally as the `UserDefaults` key for storing the OAuth
    /// credential.
    private var authorizeUrl: String

    /// The credential that's returned by the OAuth server after authentication
    /// has been successful. Setting this will also set the internal
    /// `OAuthSwiftClient`.
    internal var oAuthCredential: OAuthSwiftCredential? {
        get {
            if let cachedData = defaults.object(forKey: authorizeUrl) as? Data {
                do {
                    return try JSONDecoder().decode(OAuthSwiftCredential.self, from: cachedData)
                } catch {
                    assertionFailure("Failed to decode the cached OAuth credential: \(error.localizedDescription)")
                    
                    return nil
                }
            } else {
                return nil
            }
        }

        set {
            if newValue == nil {
                oAuthClient = nil
            } else if let credential = newValue {
                do {
                    let cachedData: Data = try JSONEncoder().encode(credential)
                    defaults.set(cachedData, forKey: authorizeUrl)
                    oAuthClient = OAuthSwiftClient(credential: credential)
                } catch {
                    assertionFailure("Failed to encode the OAuth credential: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Initialization

    /// Initialize the client with an OAuth type and an optional base URL.
    ///
    /// - parameter oAuth: The OAuth authentication mode. This will be either
    ///             `OAuth1Swift` or `OAuth2Swift`.
    /// - parameter authorizeUrl: For the purposes of this class, this is used
    ///             as the `UserDefaults` key for storing the OAuth
    ///             credential.
    /// - parameter baseUrl: The API URL that all paths will be resolved
    ///             against. If it's `nil` (the default), then each path that's
    ///             passed to the REST functions must be an absolute URL string.
    public init(oAuth: OAuthSwift,
                authorizeUrl: String,
                baseUrl: URL? = nil,
                jsonDecoder: JSONDecoder) {
        self.oAuth = oAuth
        self.authorizeUrl = authorizeUrl

        super.init(baseUrl: baseUrl, jsonDecoder: jsonDecoder)

        if let credential = oAuthCredential {
            oAuthClient = OAuthSwiftClient(credential: credential)
        }
    }

    // MARK: - Lifecycle Functions

    open func signOut() {
        oAuthCredential = nil  // also nullifies the OAuthSwift client
    }

    // MARK: - REST Functions

    /// HTTP `GET` JSON data from a path that requires client authentication to
    /// access and return it as a `Promise` of the desired `Codable` data type.
    ///
    /// - parameter path: The endpoint path, relative to the `baseUrl`.
    /// - parameter headers: The headers to send with the request. The OAuth
    ///             client will set any required authentication-related headers
    ///             itself. The default is an empty dictionary.
    /// - parameter parameters: Query parameters for the URL. The default is
    ///             empty.
    ///
    /// - returns: A `Promise<T>` to get the JSON object at the specified path.
    ///            It will be rejected if the URL is malformed, or if the JSON
    ///            data couldn't be parsed into the requested object type.
    open func authorizedGet<T: Codable>(path: String,
                                        headers: Headers = Headers(),
                                        parameters: Parameters = Parameters()) -> Promise<T> {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return JSONErr.invalidUrl(urlString: path).rejectedPromise()
        }

        return authorizedGet(url: url, headers: headers, parameters: parameters)
    }

    /// HTTP `GET` JSON data from a URL that requires client authentication to
    /// access and return it as a `Promise` of the desired `Codable` data type.
    ///
    /// - parameter path: The endpoint URL.
    /// - parameter headers: The headers to send with the request. The OAuth
    ///             client will set any required authentication-related headers
    ///             itself. The default is an empty dictionary.
    /// - parameter parameters: Query parameters for the URL. The default is
    ///             empty.
    ///
    /// - returns: A `Promise<T>` to get the JSON object at the specified URL.
    ///            It will be rejected if the URL is malformed, or if the JSON
    ///            data couldn't be parsed into the requested object type.
    open func authorizedGet<T: Codable>(url: URL,
                                        headers: Headers = Headers(),
                                        parameters: Parameters = Parameters()) -> Promise<T> {
        guard let oAuthClient = oAuthClient else {
            return JSONErr.unauthorizedAttempt.rejectedPromise()
        }

        return Promise<T> { (seal) in
            oAuthClient.get(url,
                            parameters: parameters,
                            headers: headers) { [unowned self] (result) in
                                switch result {
                                case .success(let response):
                                    do {
                                        let object: T = try self.handleSuccessfulResponse(response)
                                        seal.fulfill(object)
                                    } catch {
                                        seal.reject(error)
                                    }
                                case .failure(let error):
                                    seal.reject(error)
                                }
            }
        }
    }

    /// HTTP `POST` JSON data to a path that requires client authentication to
    /// access and return it as a `Promise` of the desired `Codable` response
    /// type.
    ///
    /// - parameter path: The endpoint path, relative to the `baseUrl`.
    /// - parameter jsonData: The JSON data to post. The default is `nil`.
    /// - parameter headers: The headers to send with the request. The OAuth
    ///             client will set any required authentication-related headers
    ///             itself. The default is an empty dictionary.
    ///
    /// - returns: A `Promise<T>` to get the JSON object at the specified path.
    ///            It will be rejected if the URL is malformed, or if the JSON
    ///            data couldn't be parsed into the requested object type.
    open func authorizedPost<T: Codable>(path: String,
                                         jsonData: Data? = nil,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return JSONErr.invalidUrl(urlString: path).rejectedPromise()
        }

        return authorizedPost(url: url, jsonData: jsonData, headers: headers)
    }

    /// HTTP `POST` JSON data to a path that requires client authentication to
    /// access and return it as a `Promise` of the desired `Codable` response
    /// type.
    ///
    /// - parameter path: The endpoint path, relative to the `baseUrl`.
    /// - parameter jsonData: The JSON data to post. The default is `nil`.
    /// - parameter headers: The headers to send with the request. The OAuth
    ///             client will set any required authentication-related headers
    ///             itself. The default is an empty dictionary.
    ///
    /// - returns: A `Promise<T>` to get the JSON object at the specified path.
    ///            It will be rejected if the URL is malformed, or if the JSON
    ///            data couldn't be parsed into the requested object type.
    open func authorizedPost<T: Codable>(path: String,
                                         object: T,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return Promise<T>(error: JSONErr.invalidUrl(urlString: path))
        }

        return authorizedPost(url: url, object: object, headers: headers)
    }

    open func authorizedPost<T: Codable>(url: URL,
                                         jsonData: Data? = nil,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        guard let oAuthClient = oAuthClient else {
            return JSONErr.unauthorizedAttempt.rejectedPromise()
        }

        return Promise<T> { (seal) in
            _ = oAuthClient.post(url,
                                 parameters: [:],
                                 headers: headers,
                                 body: jsonData) { [unowned self] (result) in
                                    switch result {
                                    case .success(let response):
                                        do {
                                            let object: T = try self.handleSuccessfulResponse(response)
                                            seal.fulfill(object)
                                        } catch {
                                            seal.reject(error)
                                        }
                                    case .failure(let error):
                                        seal.reject(error)
                                    }
            }
        }
    }

    open func authorizedPost<T: Codable>(url: URL,
                                         object: T,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        if oAuthClient == nil {
            return JSONErr.unauthorizedAttempt.rejectedPromise()
        }

        do {
            let data = try JSONEncoder().encode(object)
            return authorizedPost(url: url, jsonData: data, headers: headers)
        } catch {
            return Promise<T> { (seal) in
                seal.reject(error)
            }
        }
    }

    // MARK: - Utility functions

    internal func handle<T: Codable>(response: OAuthSwiftResponse,
                                     seal: Resolver<T>) {
        do {
            seal.fulfill(try self.handleSuccessfulResponse(response))
        } catch {
            seal.reject(JSONErr.parseFailed(error: error))
        }
    }

    /// Handle an HTTP `200` response by parsing its data into a `Codable`
    /// object.
    ///
    /// - parameter response: The response object.
    ///
    /// - returns: The parsed `Codable` object.
    ///
    /// - throws: If the `Codable` object couldn't be parsed.
    internal func handleSuccessfulResponse<T: Codable>(_ response: OAuthSwiftResponse) throws -> T {
        return try handleSuccessfulData(response.data)
    }

    /// Fulfill a seal with specified OAuth credentials. This is a convenience
    /// function borne out of a complaint by Codebeat that the `success` block
    /// in `authorize(presentingViewController:callbackUrlString:)` was
    /// duplicated in both subclasses of `AuthorizedJSONClient`.
    ///
    /// - parameter seal: The `Promise`'s resolver.
    /// - parameter withCredential: The OAuth credential.
    internal func fulfill(seal: Resolver<OAuthSwiftCredential>,
                          withCredential credential: OAuthSwiftCredential) {
        oAuthCredential = credential  // sets the OAuthSwiftClient, too.
        seal.fulfill(credential)
    }

}
