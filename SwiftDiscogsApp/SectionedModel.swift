//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

open class SectionedModel: CollectionAndTableModel {

    open var sections: [Section] = []

    override convenience public init() {
        self.init(sections: [])
    }

    public init(sections: [Section]) {
        self.sections = sections
        super.init()
    }

    // MARK: - Model

    open override func numberOfSections() -> Int {
        return sections.count
    }

    open override func headerTitle(forSection section: Int) -> String? {
        return sections[section].headerText
    }

    open class Section: NSObject {

        open var cellID: String

        open var headerText: String? = nil

        public init(cellID: String,
                    headerText: String? = nil) {
            self.cellID = cellID
            self.headerText = headerText
        }

    }

}

