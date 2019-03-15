//  Copyright © 2019 Poikile Creations. All rights reserved.

import Kingfisher
import SwiftDiscogs
import Stylobate
import UIKit

open class SongView: CollectionAndTableDisplay, DiscogsProvider {

    // MARK: - Outlets

    @IBOutlet open weak var coverArtView: UIImageView!

    @IBOutlet open weak var playbackView: UIView!

    // MARK: - DiscogsProvider

    open var discogs: Discogs?

    // MARK: - Public Properties

    open override var model: CollectionAndTableModel? {
        didSet {
            coverArtView.kf.setImage(with: (model as? SongModel)?.song?.artwork)
        }
    }

    // MARK: - UIView

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        bringSubviewToFront(playbackView)
    }

}

open class SongCreditsTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet open weak var playerNameButton: UIButton!

    @IBOutlet open weak var roleLabel: UILabel!

    // MARK: - Properties

    open var performer: Song.Performer? {
        didSet {
            playerNameButton.titleLabel?.text = performer?.name
            roleLabel.text = performer?.roles.joined(separator: ", ")
        }
    }

}

open class SongLyricsTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet open weak var lyricsLabel: UILabel!

    // MARK: - Properties

    open var song: Song? {
        didSet {
            lyricsLabel.text = song?.lyrics
        }
    }

}

open class SongNameTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet open weak var songNameLabel: UILabel!

    @IBOutlet open weak var artistButton: UIButton!

    @IBOutlet open weak var firstReleasedLabel: UILabel!

    // MARK: - Properties

    open var song: Song? {
        didSet {
            songNameLabel.text = song?.title
        }
    }

}

open class SongVersionTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet open weak var alsoKnownAsLabel: UILabel!

    @IBOutlet open weak var differentiationLabel: UILabel!

    @IBOutlet open weak var durationLabel: UILabel!

    // MARK: - Properties

    open var songVersion: Song.Version? {
        didSet {
            if let disambiguation = songVersion?.disambiguationNote {
                differentiationLabel.text = disambiguation
                differentiationLabel.isHidden = false
            } else {
                differentiationLabel.isHidden = true
            }

            if let aka = songVersion?.alternateTitle {
                alsoKnownAsLabel.text = aka
                alsoKnownAsLabel.isHidden = false
            } else {
                alsoKnownAsLabel.isHidden = true
            }

            if let duration = songVersion?.duration {
                durationLabel.text = format(duration: duration)
                durationLabel.isHidden = false
            } else {
                durationLabel.isHidden = true
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

