//  Copyright © 2018 Poikile Creations. All rights reserved.

import Kingfisher
import SwiftDiscogs
import UIKit

open class ArtistSearchResultCell: UITableViewCell {

    open var searchResult: SearchResult? {
        didSet {
            artistName = searchResult?.title
            thumbnailUrlString = searchResult?.thumb
        }
    }

    open var artistName: String? {
        didSet {
            nameLabel?.text = artistName
        }
    }

    open var thumbnailUrlString: String? {
        didSet {
            if let thumbnailUrlString = thumbnailUrlString {
                thumbnailView?.kf.setImage(with: URL(string: thumbnailUrlString))
            }
        }
    }

    @IBOutlet fileprivate weak var nameLabel: UILabel?
    @IBOutlet fileprivate weak var thumbnailView: UIImageView?

}
