//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import Foundation

public extension NSManagedObjectContext {

    func fetchOrCreate<T: NSManagedObject>(with request: NSFetchRequest<T>,
                                           initialize: (NSManagedObjectContext) -> T) throws -> T {
        // Fetch.................................or create.
        return try fetch(request).first ?? initialize(self)
    }

    /// Fetch the first existing object that matches the request, or create a
    /// new one, then update the object with the block that's passed in. Note
    /// that this will apply the block _even if_ the object already existed.
    /// Call `hasChanges` on the returned object to see whether the update
    /// block did anything meaningful.
    ///
    /// - parameter request: The fetch request. This should be constructed in
    ///             such a way that a single object (or `nil`) is returned,
    ///             because only the first matched object will be updated and
    ///             returned.
    /// - parameter update: The block to apply to the fetched or created
    ///             managed object. This will be applied to _every_ object,
    ///             even if it already exists, so it shouldn't be overly
    ///             complex. If you don't want the update to be applied to
    ///             everything, call
    ///             `NSManagedObjectContext.fetchOrCreate(with:initializer:)`
    ///             instead.
    ///
    /// - returns:  An existing or new instance of `T`, after it's been passed
    ///             into the `update` block.
    func fetchOrCreate<T: NSManagedObject>(withRequest request: NSFetchRequest<T>,
                                           updateWith update: (T) -> Void) throws -> T {
        // Fetch.................................or create.
        let object = try fetch(request).first ?? T.init(context: self)
        update(object)

        return object
    }

}
