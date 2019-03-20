//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

/// A `CollectionAndTableModel` that maintains submodules for each section.
/// These submodels (`Section`s) provide things like the cell ID and header
/// text, although they do *not* provide the cells themselves. Subclasses must,
/// therefore, still implement `tableView(_:cellForRowAt:)` and
/// `collectionView(_:cellForItemAt:)` themselves.
open class SectionedModel: CollectionAndTableModel {

    // MARK: - Public Properties
    
    /// The sections that this model maintains. The order in which they're
    /// listed must match the order in which they'll appear in the table or
    /// collection view. Sections don't need to be unique *types*, but if
    /// they're not, subclasses of this model **must** not filter or switch on
    /// the section types!
    public var sections: [Section] = []

    // MARK: - Initialization
    
    /// Construct a model with no sections. This do-nothing initializer is
    /// required by the compiler for some reason.
    public override init() {
        super.init()
    }
    
    /// Construct a model with a list of `Section`s. These sections must be in
    /// the order in which they'll appear in the table or collection view.
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

    // MARK: - Section
    
    /// A section of a table or collection view model. It provides the ID of
    /// cells in its section, as well as optional header text and custom header
    /// and footer views.
    open class Section: NSObject {

        open var cellID: String

        open var footerView: UIView? = nil

        open var headerText: String? = nil

        open var headerView: UIView? = nil

        public init(cellID: String,
                    footerView: UIView? = nil,
                    headerText: String? = nil,
                    headerView: UIView? = nil) {
            self.cellID = cellID
            self.footerView = footerView
            self.headerText = headerText
            self.headerView = headerView
        }

    }

}

