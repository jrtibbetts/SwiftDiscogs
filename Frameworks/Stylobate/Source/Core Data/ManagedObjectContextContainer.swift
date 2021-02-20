//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData

/// Implemented by classes that use a managed object context.
public protocol ManagedObjectContextContainer {

    var moContext: NSManagedObjectContext? { get set }

}
