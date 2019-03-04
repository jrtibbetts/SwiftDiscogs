//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

public class MasterReleaseView: Display {

    public var masterRelease: MasterRelease? {
        didSet {

        }
    }

}

public class TracklistTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var durationLabel: UILabel?
    @IBOutlet public weak var titleLabel: UILabel?
    @IBOutlet public weak var trackNumberLabel: UILabel?

    // MARK: - Properties

    public var track: Track? {
        didSet {
            durationLabel?.text = track?.duration
            titleLabel?.text = track?.title
            trackNumberLabel?.text = track?.position
        }
    }

}

public class ReleaseTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var titleLabel: UILabel?

    // MARK: - Properties

    public var release: ReleaseSummary? {
        didSet {
            guard let labelName = release?.label else {
                titleLabel?.text = ""
                return
            }

            guard let catalogNumber = release?.catalogNumber else {
                titleLabel?.text = labelName
                return
            }

            titleLabel?.text = "\(labelName) \(catalogNumber)"
        }
    }

}
