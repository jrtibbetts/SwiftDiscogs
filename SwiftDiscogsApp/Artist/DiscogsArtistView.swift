//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

/// The user interface for the `DiscogsArtistViewController`. It has outlets
/// for a table view and a collection view, even though only one will be
/// active at a time, depending on the device's orientation.
open class DiscogsArtistView: CollectionAndTableDisplay {

    @IBOutlet weak var mainImage: UIImageView!

    open var artistModel: DiscogsArtistModel? {
        return model as? DiscogsArtistModel
    }

    open override func refresh() {
        super.refresh()

        guard let artist = artistModel?.artist else {
            return
        }

        navigationItem?.title = artist.name

        if let imageUrlString = artist.images?.first?.resourceUrl,
            let imageUrl = URL(string: imageUrlString) {
            mainImage.kf.setImage(with: imageUrl)
        }

    }

}

public protocol DiscogsArtistBioCell {

    var bioText: String? { get set }

}

public protocol DiscogsArtistReleaseCell {

    var thumbnail: UIImage? { get set }
    var title: String? { get set }
    var year: Int? { get set }

}

public final class DiscogsArtistBioTableCell: UITableViewCell, DiscogsArtistBioCell {

    @IBOutlet weak var bioLabel: UILabel!

    @IBOutlet weak var showMoreBioButton: UIButton!

    public var bioText: String? {
        didSet {
            // Show only the first paragraph of the bio.
            if let paragraphs = bioText?.split(separator: "\r\n") {
                if let firstParagraph = paragraphs.first {
                    bioLabel.text = String(firstParagraph)
                }

                showMoreBioButton.isHidden = paragraphs.count == 1
            }
        }
    }

}

public final class DiscogsArtistReleaseTableCell: UITableViewCell, DiscogsArtistReleaseCell {

    public var inLibrary: Bool = false

    public var summary: ReleaseSummary? {
        didSet {
            title = summary?.title
            type = summary?.type
            year = summary?.year
            typeLabel.text = inLibrary ? "In library" : ""
        }
    }

    public var thumbnail: UIImage? {
        didSet {
            thumbnailView.image = thumbnail
        }
    }

    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    public var type: String? {
        didSet {
            typeLabel.text = type
        }
    }

    public var year: Int? {
        didSet {
            if let year = year {
                yearLabel.text = "\(year)"
            } else {
                yearLabel.text = nil
            }
        }
    }

    @IBOutlet private weak var thumbnailView: UIImageView!
    @IBOutlet private weak var titleLabel: HidingLabel!
    @IBOutlet private weak var typeLabel: HidingLabel!
    @IBOutlet private weak var yearLabel: HidingLabel!

}
