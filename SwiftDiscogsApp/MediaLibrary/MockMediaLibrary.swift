//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer
import UIKit

class MockMediaLibrary: NSObject, MediaLibrary {

    private var emptyMode: Bool = false

    let items: [MPMediaItem] = []

    init(emptyMode: Bool = false) {
        super.init()
        self.emptyMode = emptyMode
    }

    func artists(named: String?) -> [MPMediaItem]? {
        return (emptyMode ? nil : items)
    }

    func songs(named: String?) -> [MPMediaItem]? {
        return (emptyMode ? nil : items)
    }

    func songs(byArtistNamed: String?) -> [MPMediaItem]? {
        return (emptyMode ? nil : items)
    }


}
