//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer
import PromiseKit
import Stylobate
import SwiftDiscogs
import UIKit

class ArtistsViewController: CollectionAndTableViewController, UISearchResultsUpdating {

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
        search()
    }

    func search(forArtist artistName: String? = nil) {
        artistsDisplay?.start()

        DispatchQueue.global().async(.promise) {
            return iTunesMediaLibrary().artists(named: artistName)
            }.done { [weak self] (artists) in
                self?.artistsModel?.artistMediaItems = artists
                self?.artistsDisplay?.refresh()
            }.ensure { [weak self] in
                self?.artistsDisplay?.stop()
        }.cauterize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        model = ArtistsModel()
        artistsDisplay?.model = model
        artistsDisplay?.navigationItem = navigationItem
        artistsDisplay?.collectionView?.isHidden = true
        artistsDisplay?.stop()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self

        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.showsCancelButton = true
        navigationItem.searchController = searchController
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

    func start() {
        spinnerView.isHidden = false
    }

    func stop() {
        spinnerView.isHidden = true
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
            let firstLetters = artists?.reduce(into: Set<String>()) { (set, artist) in
                if let firstLetter = artist.first {
                    set.insert(String(firstLetter))
                }
            }

            if let firstLetters = firstLetters {
                sectionTitles = Array<String>(firstLetters).sorted()
//                sectionIndices = []
//
//                sectionTitles.forEach { (sectionTitle) in
//                     sectionIndices.append(artists?.firstIndex { $0.starts(with: sectionTitle) } ?? 0)
//                }
            }
        }
    }

    private var sectionTitles: [String] = []

//    private var sectionIndices: [Int] = []

    // MARK: - CollectionAndTableModel

    override func numberOfSections() -> Int {
        return sectionTitles.count
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

    // MARK: - UITableViewDataSource

//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return sectionTitles
//    }
//
//    func tableView(_ tableView: UITableView,
//                   sectionForSectionIndexTitle title: String,
//                   at index: Int) -> Int {
//        return sectionIndices[index]
//    }

}
