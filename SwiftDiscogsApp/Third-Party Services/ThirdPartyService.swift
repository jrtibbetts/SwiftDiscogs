//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
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

    // MARK: Properties

    var authenticationDelegate: AuthenticatedServiceDelegate? { get set }

    var isSignedIn: Bool { get set }

    var username: String? { get set }

    // MARK: Functions

    func signIn(fromViewController: UIViewController)

    func signOut(fromViewController: UIViewController)

}

// MARK: - AuthenticatedServiceDelegate

public protocol AuthenticatedServiceDelegate {

    // MARK: Functions

    func didSignIn(toService: AuthenticatedService?)

    func didSignOut(fromService: AuthenticatedService?)

    func signIn(toService: AuthenticatedService?, failedWithError: Error?)

    func willSignIn(toService: AuthenticatedService?)

    func willSignOut(fromService: AuthenticatedService?)

}

// MARK: - Importable Service

protocol ImportableService: ThirdPartyService {

    // MARK: Properties

    var importDelegate: ImportableServiceDelegate? { get set }

    var isImporting: Bool { get set }
    
    // MARK: Functions
    
    func importData(intoContext context: NSManagedObjectContext)

    func stopImportingData()

}

// MARK: - ImportableServiceDelegate

/// Implemented by entities what want to keep track of an importable service's
/// status and progress.
protocol ImportableServiceDelegate {

    // MARK: Functions

    func didBeginImporting(fromService: ImportableService?)

    func didFinishImporting(fromService: ImportableService?)

    func updated(importProgress progress: Double,
                 forService service: ImportableService?)

    func willBeginImporting(fromService: ImportableService?)

    func willFinishImporting(fromService: ImportableService?)

}

