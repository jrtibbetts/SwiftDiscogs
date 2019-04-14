//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer
import Stylobate
import UIKit

class MockMediaLibrary: NSObject, MediaLibrary {

    private var emptyMode: Bool = false

    let items: [MockMediaItem] = {
        // the explicit variable type is needed to help the Swift compiler
        // determine what jsonObject()'s T type is.
        let parsedItems: [MockMediaItem] = try! JSONUtils.jsonObject(forFileNamed: "MockMediaLibrary")

        return parsedItems
    }()

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

    class MockMediaItem: MPMediaItem, Codable {

        var mockArtist: String?
        var mockTitle: String?

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var albumArtist: String? {
            return mockArtist
        }

        override var artist: String? {
            return mockArtist
        }

        override var title: String? {
            return mockTitle
        }

    }

}
