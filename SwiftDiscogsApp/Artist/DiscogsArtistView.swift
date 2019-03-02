//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

/// The user interface for the `DiscogsArtistViewController`. It has outlets
/// for a table view and a collection view, even though only one will be
/// active at a time, depending on the device's orientation.
open class DiscogsArtistView: CollectionAndTableDisplay {

    open var artistModel: DiscogsArtistModel? {
        return model as? DiscogsArtistModel
    }

    open override func refresh() {
        navigationItem?.title = artistModel?.artist?.name
        super.refresh()
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

    @IBOutlet fileprivate weak var bioLabel: UILabel?

    public var bioText: String? {
        didSet {
            bioLabel?.text = bioText
        }
    }

}

public final class DiscogsArtistReleaseTableCell: UITableViewCell, DiscogsArtistReleaseCell {

    public var summary: ReleaseSummary? {
        didSet {
            title = summary?.title
            type = summary?.type
            year = summary?.year
        }
    }

    public var thumbnail: UIImage? {
        didSet {
            thumbnailView?.image = thumbnail
            thumbnailView?.isHidden = (thumbnail == nil)
        }
    }

    public var title: String? {
        didSet {
            titleLabel?.text = title
            titleLabel?.isHidden = (title == nil)
        }
    }

    public var type: String? {
        didSet {
            typeLabel?.text = type
            typeLabel?.isHidden = (typeLabel == nil)
        }
    }

    public var year: Int? {
        didSet {
            yearLabel?.text = "\(year ?? 0)"
            yearLabel?.isHidden = (year == nil)
        }
    }

    @IBOutlet private weak var thumbnailView: UIImageView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var typeLabel: UILabel?
    @IBOutlet private weak var yearLabel: UILabel?

}
