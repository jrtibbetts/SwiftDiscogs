//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import MediaPlayer
import UIKit

final class MediaLibraryService: ThirdPartyService, ImportableService {

    var importDelegate: ImportableServiceDelegate?

    var importer: MPMediaItemCollectionImporter?

    var isImporting: Bool = false

    init() {
        super.init(name: "iTunes (Downloaded Music)")
        image = #imageLiteral(resourceName: "Apple Music")
        serviceDescription = """
        This is the media library that's downloaded to your device.
        """
    }

    func importData(intoContext context: NSManagedObjectContext) {
        importer = MPMediaItemCollectionImporter(context: context,
                                                 mediaQuery: MPMediaQuery.songs())
        isImporting = true

        do {
            try importer?.importMedia()
        } catch {
            print("Failed to import the music library: ", error)
        }
    }

    func stopImportingData() {
        isImporting = false
        // WE CAN'T STOP! WE WON'T STOP!
    }

}
