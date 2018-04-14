//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

open class ArtistSearchResultCell: UITableViewCell {

    open var artistName: String? {
        didSet {
            nameLabel?.text = artistName
        }
    }

    open var details: String? {
        didSet {
            detailsLabel?.text = details
        }
    }

    open var thumbnailUrlString: String? {
        didSet {
//            if let thumbnailUrlString = thumbnailUrlString {
//                thumbnailView?.image = nil
//            }
        }
    }

    @IBOutlet fileprivate weak var detailsLabel: UILabel?
    @IBOutlet fileprivate weak var nameLabel: UILabel?
    @IBOutlet fileprivate weak var thumbnailView: UIImageView?

}
