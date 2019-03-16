//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

public class CoverArtAndTableView: Display, UITableViewDelegate {

    @IBOutlet public weak var coverArtView: UIImageView?
    @IBOutlet public weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
        }
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset

        if let coverArtHeight = coverArtView?.bounds.height,
            coverArtHeight > 0.0 {
            coverArtView?.alpha = offset.y / coverArtHeight
        }
    }

}
