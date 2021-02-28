//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import Stylobate
import UIKit

public class SongView: CoverArtAndTableView {

    // MARK: - Outlets

    @IBOutlet public weak var playbackView: UIView!

    // MARK: - UIView

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        bringSubviewToFront(playbackView)
    }

}

public class SongCreditsTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var playerNameButton: UIButton!

    @IBOutlet public weak var roleLabel: UILabel!

    // MARK: - Properties

    public var performer: Song.Performer? {
        didSet {
            playerNameButton.titleLabel?.text = performer?.name
            roleLabel.text = performer?.roles.joined(separator: ", ")
        }
    }

}

public class SongLyricsTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var lyricsLabel: UILabel!

    // MARK: - Properties

    public var song: Song? {
        didSet {
            lyricsLabel.text = song?.lyrics
        }
    }

}

public class SongNameTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var songNameLabel: UILabel!

    @IBOutlet public weak var artistButton: UIButton!

    @IBOutlet public weak var firstReleasedLabel: HidingLabel!

    // MARK: - Properties

    public var song: Song? {
        didSet {
            songNameLabel.text = song?.title
            artistButton.setTitle(song?.artist, for: .normal)
            // temporarily hide the firstReleaseLabel until we start getting
            // this information.
            firstReleasedLabel.isHidden = true
        }
    }

}

public class SongVersionTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var alsoKnownAsLabel: HidingLabel!

    @IBOutlet public weak var differentiationLabel: HidingLabel!

    @IBOutlet public weak var durationLabel: HidingLabel!

    // MARK: - Properties

    public var songVersion: Song.Version? {
        didSet {
            differentiationLabel.text = songVersion?.disambiguationNote
            alsoKnownAsLabel.text = songVersion?.alternateTitle

            if let duration = songVersion?.duration {
                durationLabel.text = "\(duration)"
            } else {
                durationLabel.text = nil
            }
        }
    }

    private func format(duration: TimeInterval) -> String {
        let intDuration = Int(duration)

        // This should be localized, but how? Separators are usually handled by
        // DateFormatters, but those can't be used for durations, can they?
        return "\(intDuration / 60):\(intDuration % 60)"
    }

}

public class HidingLabel: UILabel {

    public override var text: String? {
        didSet {
            self.isHidden = (text == nil)
        }
    }

}
