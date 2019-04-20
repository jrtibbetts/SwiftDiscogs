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

public protocol AuthenticatedService: ThirdPartyService {

    var authenticationDelegate: AuthenticatedServiceDelegate? { get set }

}

public protocol AuthenticatedServiceDelegate {

    func didSignIn()

    func signInFailed(error: Error?)

    func willSignIn()

}

protocol ImportableService: ThirdPartyService {

    var importDelegate: ImportableServiceDelegate? { get set }

}

/// Implemented by entities what want to keep track of an importable service's
/// status and progress.
protocol ImportableServiceDelegate {

    // MARK: - Properties

    var importProgress: Double { get set }

    // MARK: - Functions

    func didBeginImporting()

    func didFinishImporting()

    func willBeginImporting()

    func willFinishImporting()

}

