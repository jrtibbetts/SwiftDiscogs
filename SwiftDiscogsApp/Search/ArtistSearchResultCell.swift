//  Copyright © 2018 Poikile Creations. All rights reserved.

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

    public var thumbnailUrlString: String?

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var thumbnailView: UIImageView?

}
