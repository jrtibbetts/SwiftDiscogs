//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public func + (predicateA: NSPredicate, predicateB: NSPredicate) -> NSCompoundPredicate {
    return NSCompoundPredicate(andPredicateWithSubpredicates: [predicateA, predicateB])
}
