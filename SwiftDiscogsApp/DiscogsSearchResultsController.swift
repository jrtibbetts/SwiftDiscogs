//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import SwiftDiscogs
import UIKit

open class DiscogsSearchResultsController: UITableViewController {

    open var results: DiscogsSearchResults? {
        didSet {
            tableView?.reloadData()
        }
    }

    fileprivate var pendingPromise: Promise<DiscogsSearchResults>?

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.results?.count ?? 0
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = results?.results?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistSearchResultCell", for: indexPath) as! ArtistSearchResultCell

        cell.nameLabel?.text = artist?.title

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UISearchResultsUpdating

//    open func updateSearchResults(for searchController: UISearchController) {
//        if let pendingPromise = pendingPromise {
//        }
//
////        pendingPromise =
//    }

}

open class DiscogsSearchResultsView: UITableView {

}

open class ArtistSearchResultCell: UITableViewCell {

    @IBOutlet weak var thumbnailView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?

}
