//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

public protocol MissingCell: class {

    var textLabel: UILabel? { get }

}

extension MissingCell {

    func initializeUI() {
        guard let label = textLabel else {
            return
        }

        label.text = NSLocalizedString("missing_cell_text",
                                       tableName: nil,
                                       bundle: Bundle(for: type(of: self)),
                                       value: """
If you're seeing this, then the developer is using an incorrect
cell reuse identifier somewhere.
""",
                                       comment: """
Inform the user that there's a programming error with cell reuse IDs.
""")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }

}

/// A table cell that can be returned by
/// `UITableViewDataSource(_:,cellForRowAt:)` when the index path and/or reuse
/// identifier aren't valid.
@IBDesignable open class MissingTableViewCell: UITableViewCell, MissingCell {

    /// Create the cell. It's a `.default` type cell with no reuse identifier.
    public init() {
        super.init(style: .default, reuseIdentifier: nil)
        initializeUI()
    }

    /// Initialize the cell by deserializing it.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeUI()
    }

}

/// A collection cell that can be returned by
/// `UICollectionViewDataSource(_:,cellForItemAt:)` when the index path and/or
/// identifier aren't valid.
@IBDesignable open class MissingCollectionViewCell: UICollectionViewCell, MissingCell {

    public lazy var textLabel: UILabel? = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.centerInSuperview()

        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeUI()
    }

}
