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
        if let selectedIndex = artistsDisplay.indexPathForSelectedItem,
            let selectedArtistName = artistsModel.artists?[selectedIndex.row] {
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

    // MARK: - Actions

    func importDatabases(sender: Any?) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let medi8Context = appDelegate.persistentContainer.viewContext
            let importer = MPMediaItemCollectionImporter(context: medi8Context,
                                                         mediaQuery: MPMediaQuery.songs())

            do {
                try importer.importMedia()
            } catch {
                print("Failed to import the music library: ", error)
            }
        }
    }

    // MARK: - Searching

    func search(forArtist artistName: String? = nil) {
        artistsDisplay.start()

        DispatchQueue.global().async(.promise) { [weak self] in
            let artists = MediaLibraryManager.mediaLibrary.artists(named: artistName)
            self?.artistsModel.artistMediaItems = artists
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

    var artistMediaItems: [MPMediaItem]? {
        didSet {
            if let artistNames = artistMediaItems?.map({ $0.albumArtist ?? "(unknown)" }) {
                artists = Array<String>(Set<String>(artistNames)).sorted()
            }
        }
    }

    var artists: [String]? {
        didSet {
        }
    }

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

        if let cell = cell as? ArtistTableViewCell {
            cell.artistNameLabel.text = artists?[indexPath.row]
        }

        return cell
    }

}

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var artistNameLabel: UILabel!

}
