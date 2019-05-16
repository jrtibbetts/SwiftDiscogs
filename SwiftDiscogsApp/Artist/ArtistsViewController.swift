//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer
import PromiseKit
import Stylobate
import SwiftDiscogs
import UIKit

class ArtistsViewController: CollectionAndTableViewController, UISearchResultsUpdating {

    // MARK: - Properties

    var artistsDisplay: ArtistsDisplay {
        return display as! ArtistsDisplay
    }

    var artistsModel: ArtistsModel {
        return model as! ArtistsModel
    }

    // MARK: - UIViewController

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndex = artistsDisplay.indexPathForSelectedItem {
            let selectedArtistName = artistsModel.artists[selectedIndex.row]

            if segue.identifier == "showDiscogsArtist",
                let destination = segue.destination as? DiscogsArtistViewController {
                destination.artistName = selectedArtistName
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        search()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        model = ArtistsModel()
        artistsDisplay.model = model
        artistsDisplay.setUp()
    }

    // MARK: - Searching

    func search(forArtist artistName: String? = nil) {
        artistsDisplay.start()

        DispatchQueue.global().async(.promise) { [weak self] in
            let mediaLibrary = MediaLibraryManager.mediaLibrary
            let artists = mediaLibrary.artists(named: artistName)
            self?.artistsModel.artistMediaItems = artists ?? []

            artists?.forEach { (artist) in
                let artistName = artist.albumArtist ?? "(unknown)"
                self?.artistsModel.artistAlbumCounts[artistName] = mediaLibrary.albums(byArtistNamed: artistName)?.count ?? 0
            }
        }.done { [weak self] in
            self?.artistsDisplay.refresh()
        }.ensure { [weak self] in
            self?.artistsDisplay.stop()
        }.cauterize()
    }

    func updateSearchResults(for searchController: UISearchController) {
        search(forArtist: searchController.searchBar.text)
    }

}

class ArtistsDisplay: CollectionAndTableDisplay {

    // MARK: - Outlets

    @IBOutlet weak var spinnerView: UIView!

    // MARK: - Properties

    override var model: CollectionAndTableModel? {
        didSet {
            refresh()
        }
    }

    // MARK: - Functions

    func setUp() {
        collectionView?.isHidden = true
        stop()

        if let searchController = navigationItem?.searchController {
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.dimsBackgroundDuringPresentation = false
            searchController.obscuresBackgroundDuringPresentation = false

            searchController.searchBar.enablesReturnKeyAutomatically = true
            searchController.searchBar.showsCancelButton = false
        }
    }

    func start() {
        spinnerView.isHidden = false
    }

    func stop() {
        spinnerView.isHidden = true
    }

    func tearDown() {

    }

}

class ArtistsModel: CollectionAndTableModel {

    // MARK: - Properties

    var artistMediaItems: [MPMediaItem] = [] {
        didSet {
            let artistNames = artistMediaItems.map { $0.albumArtist ?? "(unknown)" }
            artists = Array<String>(Set<String>(artistNames)).sorted()
        }
    }

    var artists: [String] = []

    var artistAlbumCounts: [String: Int] = [:]

    // MARK: - CollectionAndTableModel

    override func numberOfSections() -> Int {
        return 1
    }

    override func numberOfItems(inSection section: Int) -> Int {
        return artists.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell",
                                                 for: indexPath)

        if let cell = cell as? ArtistTableViewCell {
            let artistName = artists[indexPath.row]
            cell.artistName = artistName
            cell.libraryCount = artistAlbumCounts[artistName]
            cell.collectionCountLabel.text = nil
            cell.wantlistCountLabel.text = nil
        }

        return cell
    }

}

class ArtistTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var artistNameLabel: UILabel!

    @IBOutlet weak var collectionCountLabel: UILabel!

    @IBOutlet weak var wantlistCountLabel: UILabel!

    @IBOutlet weak var libraryCountLabel: UILabel!

    // MARK: - Properties

    var artistName: String? {
        didSet {
            artistNameLabel.text = artistName
        }
    }

    var libraryCount: Int? {
        didSet {
            libraryCountLabel.text = "\(libraryCount ?? 0)"
        }
    }

}
