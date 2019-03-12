//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

public protocol TrackView: class {

    var durationLabel: UILabel? { get set }
    var titleLabel: UILabel? { get set }
    var trackNumberLabel: UILabel? { get set }

}

public extension TrackView {

    public func setUp(with track: Track) {
        durationLabel?.text = track.duration
        titleLabel?.text = track.title
        trackNumberLabel?.text = track.position
    }

}

public class TracklistTableCell: UITableViewCell, TrackView {

    // MARK: - Outlets

    @IBOutlet public weak var durationLabel: UILabel?
    @IBOutlet public weak var titleLabel: UILabel?
    @IBOutlet public weak var trackNumberLabel: UILabel?

}
