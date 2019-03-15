//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

public class TrackTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var durationLabel: UILabel?
    @IBOutlet public weak var titleLabel: UILabel?
    @IBOutlet public weak var trackNumberLabel: UILabel?

    public func setUp(with track: Track) {
        durationLabel?.text = track.duration
        titleLabel?.text = track.title
        trackNumberLabel?.text = track.position
    }

}
