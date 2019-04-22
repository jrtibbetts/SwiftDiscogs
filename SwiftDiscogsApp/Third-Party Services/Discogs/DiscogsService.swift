//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import PromiseKit
import SwiftDiscogs

/// Encapsulates interactions with the Discogs service. Many Discogs server
/// calls require authentication, so this is an `AuthenticatedService`.
class DiscogsService: ThirdPartyService, AuthenticatedService, ImportableService {

    // MARK: - Initialization

    init() {
        super.init(name: "Discogs")
        image = #imageLiteral(resourceName: "Discogs")
        serviceDescription = """
        We're on a mission to build the biggest and most comprehensive music \
        database and marketplace. Imagine a site with discographies of all \
        labels, all artists, all cross-referenced, and an international \
        marketplace built off of that database. It's for the love of music, \
        and we're getting closer every day. (www.discogs.com/about)
        """

        DiscogsManager.discogs.userIdentity().done { [weak self] (userIdentity) in
            self?.handle(userIdentity: userIdentity)
            }.catch { (error) in
                print("Couldn't sign in", error)
        }
    }

    // MARK: - AuthenticatedService

    // MARK: Properties

    /// Called when Discogs authentication is in progress.
    var authenticationDelegate: AuthenticatedServiceDelegate?

    /// Indicates whether sign in was successful, or if the user is already
    /// signed in.
    var isSignedIn: Bool = false

    /// The user's Discogs username.
    var username: String?

    // MARK: Functions

    /// Sign into the Discogs service, notifying the display when it's about to
    /// do so and after the user has logged in successfully.
    func signIn(fromViewController viewController: UIViewController) {
        guard !isSignedIn else {
            return
        }

        authenticationDelegate?.willSignIn(toService: self)

        let promise = DiscogsManager.discogs.authorize(presentingViewController: viewController,
                                                       callbackUrlString: AppDelegate.callbackUrl.absoluteString)
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
        username = userIdentity.username
        isSignedIn = true
        authenticationDelegate?.didSignIn(toService: self)
    }

    // MARK: - ImportableService

    // MARK: Properties

    /// Called when the user's Discogs collection is being imported.
    var importDelegate: ImportableServiceDelegate?

    var importProgress: (Int, Int) = (0, 0) {
        didSet {
            importDelegate?.update(importedItemCount: importProgress.0, totalCount: importProgress.1, forService: self)
        }
    }
    
    var isImporting: Bool = false

    // MARK: Functions

    func importData(intoContext context: NSManagedObjectContext) {
        if let username = username {
            importDelegate?.willBeginImporting(fromService: self)
            isImporting = true
            importDelegate?.didBeginImporting(fromService: self)
            DiscogsManager.discogs.collectionItems(forFolderId: 0,
                                                   userName: username,
                                                   pageNumber: 1,
                                                   resultsPerPage: 40).done { [weak self] (folderItems) in
                                                    if let self = self,
                                                        let collectionItems = folderItems.releases {
                                                        self.importCollectionItems(collectionItems,
                                                                                   intoContext: context,
                                                                                   totalItems: collectionItems.count,
                                                                                   importedItemCount: 0)
                                                        self.stopImportingData()
                                                    }
                }.cauterize()
        }
    }

    func stopImportingData() {
        importDelegate?.willFinishImporting(fromService: self)
        isImporting = false
        importDelegate?.didFinishImporting(fromService: self)
    }

    private func importCollectionItems(_ items: [CollectionFolderItem],
                                       intoContext context: NSManagedObjectContext,
                                       totalItems: Int,
                                       importedItemCount: Int) {
        var importedItemsInThisBatch = 0
        items.forEach { (item) in
            importItem(item, intoContext: context)
            importedItemsInThisBatch += 1
            let allImportedItemsCount = importedItemCount + importedItemsInThisBatch

            if (allImportedItemsCount) / 5 == 0 {
                importDelegate?.update(importedItemCount: allImportedItemsCount,
                                       totalCount: totalItems,
                                       forService: self)
            }
        }
    }

    private func importItem(_ item: CollectionFolderItem,
                            intoContext context: NSManagedObjectContext) {
        print("Importing ", item)

        if let info = item.basicInformation {
            info.artists?.forEach { (artistSummary) in
                
            }
        }
    }

}
