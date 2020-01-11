//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import PromiseKit
import Stylobate
import SwiftDiscogs

/// Encapsulates interactions with the Discogs service. Many Discogs server
/// calls require authentication, so this is an `AuthenticatedService`.
class DiscogsService: ThirdPartyService, AuthenticatedService, ImportableService {

    // MARK: - Singleton

    static let instance = DiscogsService()

    // MARK: - Initialization

    private init() {
        super.init(name: "Discogs")
        image = #imageLiteral(resourceName: "Discogs")
        serviceDescription = """
        We're on a mission to build the biggest and most comprehensive music \
        database and marketplace. Imagine a site with discographies of all \
        labels, all artists, all cross-referenced, and an international \
        marketplace built off of that database. It's for the love of music, \
        and we're getting closer every day. (www.discogs.com/about)
        """

        DiscogsManager.discogs.userIdentity().then { [weak self] (userIdentity) -> Promise<UserProfile> in
            self?.handle(userIdentity: userIdentity)
            return DiscogsManager.discogs.userProfile(userName: userIdentity.username)
            }.done { [weak self] (userProfile) in
                self?.userProfile = userProfile
            }.cauterize()
    }

    // MARK: - AuthenticatedService

    // MARK: Properties

    /// Called when Discogs authentication is in progress.
    var authenticationDelegate: AuthenticatedServiceDelegate?

    var importableItemCount: Int? {
        return userProfile?.numCollection
    }

    var importedItemCount: Int = 0 {
        didSet {
            if importedItemCount % 5 == 0 {
                importDelegate?.update(importedItemCount: importedItemCount,
                                       totalCount: importableItemCount,
                                       forService: self)
            }
        }
    }

    /// Indicates whether sign in was successful, or if the user is already
    /// signed in.
    var isSignedIn: Bool = false

    var userIdentity: UserIdentity?

    /// The user's Discogs username.
    var userName: String? {
        return userIdentity?.username
    }

    var userProfile: UserProfile?

    // MARK: Functions

    /// Sign into the Discogs service, notifying the display when it's about to
    /// do so and after the user has logged in successfully.
    func signIn(fromViewController viewController: UIViewController) {
        guard !isSignedIn else {
            return
        }

        authenticationDelegate?.willSignIn(toService: self)

        let promise = DiscogsManager.discogs.authorize(presentingViewController: viewController,
                                                       callbackUrlString: AppDelegate.shared.callbackUrl.absoluteString)
        promise.then { (credential) -> Promise<UserIdentity> in
            return DiscogsManager.discogs.userIdentity()
            }.done { [weak self] (userIdentity) in
                self?.handle(userIdentity: userIdentity)
            }.catch { [weak self] (error) in
                self?.isSignedIn = false
                self?.authenticationDelegate?.signIn(toService: self, failedWithError: error)
                viewController.presentAlert(for: error, title: L10n.discogsSignInFailed)
        }
    }

    func signOut(fromViewController: UIViewController) {
        authenticationDelegate?.willSignOut(fromService: self)
        DiscogsManager.discogs.signOut()
        isSignedIn = false
        authenticationDelegate?.didSignOut(fromService: self)
    }

    func handle(userIdentity: UserIdentity) {
        self.userIdentity = userIdentity
        isSignedIn = true
        authenticationDelegate?.didSignIn(toService: self)
    }

    // MARK: - ImportableService

    // MARK: Properties

    /// Called when the user's Discogs collection is being imported.
    weak var importDelegate: ImportableServiceDelegate?

    var isImporting: Bool = false

    // MARK: Functions

    func importData() {
        let context = AppDelegate.shared.medi8Context

        if let username = userName {
            importDelegate?.willBeginImporting(fromService: self)
            isImporting = true
            importDelegate?.didBeginImporting(fromService: self)

            let subcontext = DiscogsCollectionImporter(concurrencyType: .privateQueueConcurrencyType)
            subcontext.service = self
            subcontext.importerDelegate = importDelegate
            subcontext.parent = context
            subcontext.perform { [weak self] in
                subcontext.importDiscogsCollection(forUserName: username).done {
                    try context.save()
                    print("Imported")
                    print("\(try CustomField.all(inContext: context).count) fields")
                    print("\(try CollectionItem.all(inContext: context).count) items")
                    print("\(try Folder.all(inContext: context).count) folders")
                }.catch { (error) in
                    DispatchQueue.main.async { [weak self] in
                        self?.isImporting = false
                        self?.importDelegate?.importFailed(fromService: self, withError: error)
                    }
                }
            }
        }
    }

    func stopImportingData() {
        importDelegate?.willFinishImporting(fromService: self)
        isImporting = false
        importDelegate?.didFinishImporting(fromService: self)
    }

}
