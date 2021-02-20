//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData

/// Implemented by objects that have an `NSFetchedResultsController`.
public protocol FetchedResultsProvider: ManagedObjectContextContainer, NSFetchedResultsControllerDelegate {

    associatedtype ManagedObjectType: NSManagedObject

    /// Set up the fetched results controller. This has a default
    /// implementation, so implementers of this protocol usually don't need to
    /// provide their own implementation.
    func fetchedResultsController(for fetchRequest: NSFetchRequest<ManagedObjectType>,
                                  sectionNameKeyPath: String?,
                                  cacheName: String?) throws
        -> NSFetchedResultsController<ManagedObjectType>?

}

extension FetchedResultsProvider {

    /// Configure the fetched results controller with a fetch request, then
    /// perform a fetch on it.
    ///
    /// - parameter fetchRequest: The request that's been configured with the
    ///   desired sort order and predicate.
    /// - parameter sectionNameKeyPath: The default is `nil`.
    /// - parameter cacheName: The name that will be displayed by the debugger
    ///             for the optional result cache. The default is `nil`.
    public func fetchedResultsController(for fetchRequest: NSFetchRequest<ManagedObjectType>,
                                         sectionNameKeyPath: String? = nil,
                                         cacheName: String? = nil) throws
        -> NSFetchedResultsController<ManagedObjectType>? {
            guard let context = moContext else {
                return nil
            }

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: sectionNameKeyPath,
                                                                  cacheName: cacheName)
        fetchedResultsController.delegate = self
        try fetchedResultsController.performFetch()

        return fetchedResultsController
    }

}
