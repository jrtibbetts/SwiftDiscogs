//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer
import PromiseKit
import Stylobate
import SwiftDiscogs
import UIKit

class ArtistsViewController: CollectionAndTableViewController {

    // MARK: - Properties

    var artistsDisplay: ArtistsDisplay? {
        return display as? ArtistsDisplay
    }

    var artistsModel: ArtistsModel? {
        return model as? ArtistsModel
    }

    // MARK: - UIViewController

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndex = artistsDisplay?.indexPathForSelectedItem,
            let selectedArtistName = artistsModel?.artists?[selectedIndex.row] {
            if segue.identifier == "searchDiscogsForArtist",
                let destination = segue.destination as? DiscogsSearchViewController {
                destination.search(forArtistNamed: selectedArtistName)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // How do I run this promise on a background thread?
        _ = Promise<[MPMediaItem]?>() { (seal) in
            seal.fulfill(MPMediaQuery.artists().items)
            }.done { [weak self] (artists) in
                self?.artistsModel?.artistMediaItems = artists
                self?.artistsDisplay?.refresh()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        model = ArtistsModel()
        artistsDisplay?.model = model
        artistsDisplay?.navigationItem = navigationItem
        artistsDisplay?.collectionView?.isHidden = true
    }

}

class ArtistsDisplay: CollectionAndTableDisplay {

    override var model: CollectionAndTableModel? {
        didSet {
            refresh()
        }
    }

}

class ArtistsModel: CollectionAndTableModel {

    // MARK: - Properties

    var artistMediaItems: [MPMediaItem]? {
        didSet {
            if let artistNames = artistMediaItems?.map({ $0.albumArtist ?? "(unknown)" }) {
                artists = Array<String>(Set<String>(artistNames)).sorted()
            }
        }
    }

    var artists: [String]?

    // MARK: - CollectionAndTableModel

    override func numberOfSections() -> Int {
        return 1
    }

    override func numberOfItems(inSection section: Int) -> Int {
        return artists?.count ?? 0
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell",
                                                 for: indexPath)
        cell.textLabel?.text = artists?[indexPath.row]

        return cell
    }

}
