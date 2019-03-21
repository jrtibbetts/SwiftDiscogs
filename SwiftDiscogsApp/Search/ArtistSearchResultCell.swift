//  Copyright © 2018 Poikile Creations. All rights reserved.

import Kingfisher
import SwiftDiscogs
import UIKit

public class ArtistSearchResultCell: UITableViewCell {

    public var searchResult: SearchResult? {
        didSet {
            artistName = searchResult?.title
            thumbnailUrlString = searchResult?.thumb
        }
    }

    public var artistName: String? {
        didSet {
            nameLabel?.text = artistName
        }
    }

    public var thumbnailUrlString: String? {
        didSet {
            if let thumbnailUrlString = thumbnailUrlString {
                thumbnailView?.kf.setImage(with: URL(string: thumbnailUrlString))
            }
        }
    }

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var thumbnailView: UIImageView?

}
