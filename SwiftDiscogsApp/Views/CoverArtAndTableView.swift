//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

public class CoverArtAndTableView: Display, UITableViewDelegate {

    // MARK: - Outlets

    @IBOutlet public weak var coverArtView: UIImageView?
    @IBOutlet public weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = model
        }
    }

    // MARK: - Public Properties

    public var model: UITableViewDataSource? {
        didSet {
            tableView?.dataSource = model
            refresh()
        }
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset

        if let coverArtHeight = coverArtView?.bounds.height,
            coverArtHeight > 0.0 {
            coverArtView?.alpha = 1.0 - (offset.y / coverArtHeight)
        }
    }

    // MARK: - UIView

    public override func refresh() {
        super.refresh()
        tableView?.reloadData()
    }

}
