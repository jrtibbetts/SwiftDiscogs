//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import OAuthSwift
import PromiseKit
import XCTest

class AuthorizedJSONClientTests: JSONClientTests {
    
    override func validJSONClient(baseUrl: URL? = nil) -> JSONClient {
        let oAuth = OAuth1Swift(consumerKey: "foo", consumerSecret: "bar")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return AuthorizedJSONClient(oAuth: oAuth,
                                    authorizeUrl: "http://www.cnn.com",
                                    baseUrl: baseUrl,
                                    jsonDecoder: decoder)
    }

    func testAuthorizedGetWithPathBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let promise: Promise<DiscogsInfo> = client.authorizedGet(path: "/some/path")
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func testAuthorizedGetWithUrlBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let url = URL(string: "https://api.discogs.com")!
        let promise: Promise<DiscogsInfo> = client.authorizedGet(url: url)
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func testAuthorizedPostWithPathBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let path = "https://api.discogs.com"
        let promise: Promise<DiscogsInfo> = client.authorizedPost(path: path)
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func testAuthorizedPostWithPathAndDataBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let path = "https://api.discogs.com"
        let string = "This is the payload to be posted."
        let promise: Promise<String> = client.authorizedPost(path: path, object: string)
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func testAuthorizedPostWithUrlBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let url = URL(string: "https://api.discogs.com")!
        let promise: Promise<DiscogsInfo> = client.authorizedPost(url: url)
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func testAuthorizedPostWithUrlAndDataBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let url = URL(string: "https://api.discogs.com")!
        let string = "This is the payload to be posted."
        let promise: Promise<String> = client.authorizedPost(url: url, object: string)
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func testHandleSuccessfulResponseOk() {
        // Make up some valid data.
        let url = URL(string: "https://api.discogs.com")!
        let stats = DiscogsInfo.Stats(labels: 500, artists: 1000, releases: 1000)
        let discogsInfo = DiscogsInfo(apiVersion: "1.0", documentationUrl: url, hello: "Hello, world", statistics: stats)

        // Construct fake HTTP and OAuth responses.
        let httpResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!

        do {
            let oAuthResponse = try OAuthSwiftResponse(data: JSONEncoder().encode(discogsInfo), response: httpResponse, request: nil)
            let client = validJSONClient() as! AuthorizedJSONClient
            let unpackedInfo: DiscogsInfo = try client.handleSuccessfulResponse(oAuthResponse)
            XCTAssertEqual(unpackedInfo.hello, discogsInfo.hello)
        } catch {
            XCTFail("Couldn't construct the expected object from the data: \(error.localizedDescription)")
        }
    }

    func testHandleSuccessfulResponseWithMismatchedTypesThrows() {
        // Make up some valid data.
        let url = URL(string: "https://api.discogs.com")!
        let stats = DiscogsInfo.Stats(labels: 500, artists: 1000, releases: 1000)
        let discogsInfo = DiscogsInfo(apiVersion: "1.0", documentationUrl: url, hello: "Hello, world", statistics: stats)

        // Construct fake HTTP and OAuth responses.
        let httpResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!

        do {
            let oAuthResponse = try OAuthSwiftResponse(data: JSONEncoder().encode(discogsInfo), response: httpResponse, request: nil)
            let client = validJSONClient() as! AuthorizedJSONClient
            let _: String = try client.handleSuccessfulResponse(oAuthResponse)
            XCTFail("Expected an error to be thrown")
        } catch {
            // Sweet.
        }
    }

    func testSetCredentialInStandardDefaultsOk() {
        let key = "aslkdfj3q4fal;ksdfjal;skdfj"
        let secret = "asdlkfj3l4kjrtl;kad meerlktjl;3k4j"
        let credential = OAuthSwiftCredential(consumerKey: key, consumerSecret: secret)

        let client = validJSONClient() as! AuthorizedJSONClient
        let originalDefaults = client.defaults  // reset the client.defaults to this later
        client.defaults = UserDefaults(suiteName: self.name)!  // custom defaults for testing
        client.oAuthCredential = credential
        let decodedCredential = client.oAuthCredential
        XCTAssertEqual(credential, decodedCredential)

        client.oAuthCredential = nil
        client.defaults = originalDefaults
    }

    func assert<T: Codable>(promise: Promise<T>,
                            wasUnauthorizedWithMessage errorMessage: String) {
        let exp = expectation(description: errorMessage)

        promise.done { (obj) -> Void in
            XCTFail(errorMessage)
            }.catch { (error) in
                guard let error = error as? JSONClient.JSONErr else {
                    XCTFail(errorMessage)
                    return
                }

                switch error {
                case .unauthorizedAttempt:
                    exp.fulfill()
                default:
                    XCTFail(errorMessage)
                }
        }

        wait(for: [exp], timeout: 5.0)
    }

}

class OAuth1JSONClientTests: AuthorizedJSONClientTests {

    override func validJSONClient(baseUrl: URL? = nil) -> JSONClient {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return OAuth1JSONClient(consumerKey: "foo",
                                consumerSecret: "bar",
                                requestTokenUrl: "one",
                                authorizeUrl: "two",
                                accessTokenUrl: "three",
                                baseUrl: baseUrl,
                                jsonDecoder: jsonDecoder)
    }

}

class OAuth2JSONClientTests: AuthorizedJSONClientTests {

    override func validJSONClient(baseUrl: URL? = nil) -> JSONClient {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return OAuth2JSONClient(consumerKey: "foo",
                                consumerSecret: "bar",
                                authorizeUrl: "one",
                                accessTokenUrl: "two",
                                baseUrl: baseUrl,
                                jsonDecoder: jsonDecoder)
    }

}
