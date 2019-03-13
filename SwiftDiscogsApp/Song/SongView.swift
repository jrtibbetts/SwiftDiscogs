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

}

open class SongCreditsTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet open weak var playerNameButton: UIButton!

    @IBOutlet open weak var roleLabel: UILabel!

}

open class SongLyricsTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet open weak var lyricsLabel: UILabel!

}

open class SongNameTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet open weak var songNameLabel: UILabel!

    @IBOutlet open weak var artistButton: UIButton!

    @IBOutlet open weak var firstReleasedLabel: UILabel!

}

open class SongVersionTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet open weak var alsoKnownAsLabel: UILabel!

    @IBOutlet open weak var differentiationLabel: UILabel!

    @IBOutlet open weak var durationLabel: UILabel!

}

