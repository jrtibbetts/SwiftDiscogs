//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer
import UIKit

final class MediaLibraryService: ThirdPartyService, ImportableService {

    var importDelegate: ImportableServiceDelegate?

    init() {
        super.init(name: "iTunes (Downloaded Music)")
        image = #imageLiteral(resourceName: "Apple Music")
    }
    
}
