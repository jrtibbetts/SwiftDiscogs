//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import MediaPlayer
import UIKit

final class MediaLibraryService: ThirdPartyService, ImportableService {

    var importableItemCount: Int?

    var importedItemCount: Int = 0 {
        didSet {
            importDelegate?.update(importedItemCount: importedItemCount,
                                   totalCount: importableItemCount,
                                   forService: self)
        }
    }

    weak var importDelegate: ImportableServiceDelegate?

    var importer: MPMediaItemCollectionImporter?

    var isImporting: Bool = false

    init() {
        super.init(name: "iTunes (Downloaded Music)")
        image = #imageLiteral(resourceName: "Apple Music")
        serviceDescription = """
        This is the media library that's downloaded to your device.
        """
    }

    func importData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.medi8Container.viewContext
            importer = MPMediaItemCollectionImporter(context: context,
                                                     mediaQuery: MPMediaQuery.songs())
            isImporting = true

            do {
                try importer?.importMedia()
            } catch {
                importDelegate?.importFailed(fromService: self, withError: error)
            }
        }
    }

    func stopImportingData() {
        isImporting = false
        // WE CAN'T STOP! WE WON'T STOP!
    }

}
