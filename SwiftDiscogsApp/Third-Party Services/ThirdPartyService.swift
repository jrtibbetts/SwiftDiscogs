//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

open class ThirdPartyService: NSObject {

    // MARK: - Properties

    var image: UIImage?

    var name: String

    var serviceDescription: String?

    // MARK: - Initialization

    init(name: String) {
        self.name = name
        super.init()
    }

}

// MARK: - AuthenticatedService

public protocol AuthenticatedService: ThirdPartyService {

    var authenticationDelegate: AuthenticatedServiceDelegate? { get set }

    var isSignedIn: Bool { get set }

    var username: String? { get set }

}

// MARK: - AuthenticatedServiceDelegate

public protocol AuthenticatedServiceDelegate {

    func didSignIn(toService: AuthenticatedService?)

    func signIn(toService: AuthenticatedService?, failedWithError: Error?)

    func willSignIn(toService: AuthenticatedService?)

}

// MARK: - Importable Service

protocol ImportableService: ThirdPartyService {

    var importDelegate: ImportableServiceDelegate? { get set }

}

// MARK: - ImportableServiceDelegate

/// Implemented by entities what want to keep track of an importable service's
/// status and progress.
protocol ImportableServiceDelegate {

    // MARK: Properties

    var importProgress: Double { get set }

    // MARK: Functions

    func didBeginImporting(fromService: ImportableService?)

    func didFinishImporting(fromService: ImportableService?)

    func willBeginImporting(fromService: ImportableService?)

    func willFinishImporting(fromService: ImportableService?)

}

