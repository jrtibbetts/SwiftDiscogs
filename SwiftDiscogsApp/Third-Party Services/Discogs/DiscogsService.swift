//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import PromiseKit
import Stylobate
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
    var importDelegate: ImportableServiceDelegate?
    
    var isImporting: Bool = false

    // MARK: Functions

    func importData() {
        let context = AppDelegate.shared.medi8Context

        if let username = userName {
            importDelegate?.willBeginImporting(fromService: self)
            isImporting = true
            importDelegate?.didBeginImporting(fromService: self)

            let subcontext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            subcontext.parent = context
            subcontext.perform { [weak self] in
                do {
                    try self?.importCustomFields(inContext: subcontext)
                    try self?.importAllItems(forUserName: username, inContext: subcontext)
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.isImporting = false
                        self?.importDelegate?.importFailed(fromService: self, withError: error)
                    }
                }
            }
        }
    }

    func importCustomFields(inContext context: NSManagedObjectContext) throws {
        guard let userName = userName else {
            return
        }

        DiscogsManager.discogs.customCollectionFields(forUserName: userName).done { (fields) in
            fields.fields?.forEach { (discogsField) in
                do {
                    _ = try discogsField.fetchOrCreateEntity(inContext: context)
                } catch {
                    print("Failed to create a custom field for \(discogsField)", error)
                }
            }
        }.cauterize()
    }

    func importAllItems(forUserName userName: String,
                        inContext context: NSManagedObjectContext) throws {
        guard let importableItemCount = importableItemCount else {
            return
        }

        let folder = try fetchOrCreateFolder(folderID: 0,
                                             inContext: context)
        folder.name = "Everything"
        let pageSize = 100
        let totalPages = (importableItemCount / pageSize) + 1

//        let allItemsRequest: NSFetchRequest<CollectionItem> = CollectionItem.fetchRequest()
//        allItemsRequest.sortDescriptors = [(\CollectionItem.releaseVersionID).sortDescriptor()]
//        let allItems: [CollectionItem] = try context.fetch(allItemsRequest)

        (1..<totalPages).forEach { (pageNumber) in
            guard isImporting else {
                return
            }

            DiscogsManager.discogs.collectionItems(inFolderID: 0,
                                                   userName: userName,
                                                   pageNumber: pageNumber,
                                                   resultsPerPage: pageSize).done { [weak self] (folderItems) in
                                                    if let self = self,
                                                        let collectionItems = folderItems.releases {
                                                        self.importCollectionItems(collectionItems,
                                                                                   inFolder: folder,
                                                                                   intoContext: context,
                                                                                   totalItems: self.importableItemCount)
                                                    }

                                                    try context.save()
                                                    try context.parent?.save()
                }.cauterize()
        }

//        stopImportingData()
    }

    func stopImportingData() {
        importDelegate?.willFinishImporting(fromService: self)
        isImporting = false
        importDelegate?.didFinishImporting(fromService: self)
    }

    private func importCollectionItems(_ items: [CollectionFolderItem],
                                       inFolder folder: Folder,
                                       intoContext context: NSManagedObjectContext,
                                       totalItems: Int?) {
        guard isImporting else {
            return
        }

        items.forEach { (item) in
            importItem(item, inFolder: folder, intoContext: context)
        }
    }

    private func importItem(_ item: CollectionFolderItem,
                            inFolder folder: Folder,
                            intoContext context: NSManagedObjectContext) {
        guard isImporting else {
            return
        }

        print("Importing ", item)

        do {
            let coreDataItem = try fetchOrCreateItem(forDiscogsCollectionItem: item,
                                                     inContext: context)
            folder.addToItems(coreDataItem)
            importedItemCount += 1
        } catch {
            print("Failed to import Discogs collection folder item", item, error)
        }
    }

    private func fetchOrCreateFolder(folderID: Int,
                                     inContext context: NSManagedObjectContext) throws -> Folder {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest(sortDescriptors: [(\Folder.folderID).sortDescriptor()],
                                          predicate: NSPredicate(format: "folderID = \(folderID)"))

        return try context.fetchOrCreate(with: request) { (context) -> Folder in
            let folder = Folder(context: context)
            folder.folderID = Int64(folderID)

            return folder
        }
    }

    private func fetchOrCreateItem(forDiscogsCollectionItem discogsCollectionItem: SwiftDiscogs.CollectionFolderItem,
                                   inContext context: NSManagedObjectContext) throws -> CollectionItem {
        let releaseVersionID = discogsCollectionItem.id
        let request: NSFetchRequest<CollectionItem> = CollectionItem.fetchRequest(sortDescriptors: [(\CollectionItem.releaseVersionID).sortDescriptor()],
                                              predicate: NSPredicate(format: "releaseVersionID = \(releaseVersionID)"))

        return try context.fetchOrCreate(with: request) { (context) -> CollectionItem in
            return CollectionItem(fromDiscogsItem: discogsCollectionItem, inContext: context)
        }
    }

}
