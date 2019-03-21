//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs

public class MediaSourcesViewController: CollectionAndTableViewController {

    public var mediaSourcesDisplay: MediaSourcesDisplay? {
        return display as? MediaSourcesDisplay
    }

    public var mediaSourcesModel: MediaSourcesModel? {
        return model as? MediaSourcesModel
    }

}

public class MediaSourcesDisplay: CollectionAndTableDisplay {

}

public class MediaSourcesModel: CollectionAndTableModel {

    public var sources: [MediaSource]

    public init(sources: [MediaSource] = []) {
        self.sources = sources
    }

    public class MediaSource: NSObject {

        // MARK: - Public Properties

        public var iconURL: URL?

        public var name: String

        // MARK: - Initialization

        public init(name: String, iconURL: URL? = nil) {
            self.name = name
            self.iconURL = iconURL
        }
    }

}
