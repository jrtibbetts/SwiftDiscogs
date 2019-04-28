//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import SwiftDiscogs

public extension CollectionItem {

    convenience init(fromDiscogsItem discogsItem: SwiftDiscogs.CollectionFolderItem,
                     inContext context: NSManagedObjectContext) {
        self.init(context: context)
        self.rating = Int16(discogsItem.rating)
        self.releaseVersionID = Int64(discogsItem.id)
    }

}
