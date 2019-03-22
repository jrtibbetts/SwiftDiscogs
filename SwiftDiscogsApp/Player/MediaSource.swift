//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public class MediaSource: NSObject {

    public enum AuthenticationStatus {
        case signedIn(username: String)
        case signedOut
        case signingIn
    }

    // MARK: - Public Properties

    public var authenticationStatus: AuthenticationStatus?

    public var iconURL: URL?

    public var name: String

    // MARK: - Initialization

    public init(name: String, iconURL: URL? = nil) {
        self.name = name
        self.iconURL = iconURL
    }
}
