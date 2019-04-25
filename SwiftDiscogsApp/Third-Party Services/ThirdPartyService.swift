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

    var isSignedIn: Bool { get }

    var userName: String? { get }

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

/// Implemented by services that have data that can be imported into the app.
protocol ImportableService: ThirdPartyService {

    // MARK: Properties

    /// The delegate which gets notified when the import starts, stops, and has
    /// progressed.
    var importDelegate: ImportableServiceDelegate? { get set }

    /// The import's progress percentage, expressed as a tuple of integers where
    /// the first one is the number of items processed, and the second is the
    /// *total* number of items (**not** the number of items remaining!)
    var importProgress: (Int, Int) { get }

    /// `true` if the import process is currently in progress.
    var isImporting: Bool { get }
    
    // MARK: Functions

    /// Start importing data into a specified Core Data context.
    func importData()

    /// Stop importing the data.
    func stopImportingData()

}

// MARK: - ImportableServiceDelegate

/// Implemented by entities what want to keep track of an importable service's
/// status and progress.
protocol ImportableServiceDelegate {

    // MARK: Functions

    func didBeginImporting(fromService: ImportableService?)

    func didFinishImporting(fromService: ImportableService?)

    func importFailed(fromService: ImportableService?,
                      withError: Error)
    
    func update(importedItemCount: Int,
                totalCount: Int,
                forService service: ImportableService?)

    func willBeginImporting(fromService: ImportableService?)

    func willFinishImporting(fromService: ImportableService?)

}

