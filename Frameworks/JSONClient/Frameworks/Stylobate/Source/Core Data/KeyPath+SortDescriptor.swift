//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public extension KeyPath {

    /// Get an `NSSortDescriptor` whose key is this key path. Calling it like
    /// `(\WidgetHolder.widgetCount).sortDescriptor(ascending: false)`
    ///
    /// - parameter ascending: `true` if the sort order should be ascending.
    ///   The default is `true`.
    func sortDescriptor(ascending: Bool = true) -> NSSortDescriptor {
        return NSSortDescriptor(keyPath: self, ascending: ascending)
    }

}
