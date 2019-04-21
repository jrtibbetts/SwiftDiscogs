//  Copyright © 2019 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs

/// Encapsulates interactions with the Discogs service. Many Discogs server
/// calls require authentication, so this is an `AuthenticatedService`.
class DiscogsService: ThirdPartyService, ImportableService, AuthenticatedService {

    // MARK: - Properties

    /// Called when Discogs authentication is in progress.
    var authenticationDelegate: AuthenticatedServiceDelegate?

    /// Called when the user's Discogs collection is being imported.
    var importDelegate: ImportableServiceDelegate?

    var isSignedIn: Bool = false

    var username: String?

    // MARK: - Initialization

    init() {
        super.init(name: "Discogs")
        image = #imageLiteral(resourceName: "Discogs")

        DiscogsManager.discogs.userIdentity().done { [weak self] (userIdentity) in
            self?.handle(userIdentity: userIdentity)
        }.cauterize() // ignore any errors or return values
    }

    // MARK: - Functions

    /// Sign into the Discogs service, notifying the display when it's about to
    /// do so and after the user has logged in successfully.
    func signIn(fromViewController viewController: UIViewController) {
        authenticationDelegate?.willSignIn()

        let promise = DiscogsManager.discogs.authorize(presentingViewController: viewController,
                                                       callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise.then { (credential) -> Promise<UserIdentity> in
            return DiscogsManager.discogs.userIdentity()
            }.done { [weak self] (userIdentity) in
                self?.handle(userIdentity: userIdentity)
                self?.authenticationDelegate?.didSignIn()
            }.catch { [weak self] (error) in
                self?.isSignedIn = false
                self?.authenticationDelegate?.signInFailed(error: error)
                viewController.presentAlert(for: error, title: L10n.discogsSignInFailed)
        }
    }

    func handle(userIdentity: UserIdentity) {
        username = userIdentity.username
        isSignedIn = true
        authenticationDelegate?.didSignIn()
    }

}
