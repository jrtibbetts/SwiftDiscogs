//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

/// A view controller for displaying details about a `DiscogsArtist`.
public class DiscogsArtistViewController: UIViewController {

    // MARK: Public Properties

    /// The Discogs client. By default, this is the singleton instance of
    /// `DiscogsClient`, but it can be changed, which can be useful for
    /// testing.
    public var discogs: Discogs? = DiscogsClient.singleton

    /// The artist in question.
    public var artist: Artist? {
        didSet {
            artistModel.artist = artist
            artistView?.refresh()

            // Now go get the artist's release summaries.
            fetchReleases()
        }
    }

    public var artistName: String? {
        didSet {
            guard let artistName = artistName else {
                return
            }

            fetchArtist(named: artistName)
        }
    }

    public var artistSearchResult: SearchResult? {
        didSet {
            if let artistId = artistSearchResult?.id {
                discogs?.artist(identifier: artistId).done { (artist) in
                    self.artist = artist
                    }.catch { (error) in
                        // HANDLE THE ERROR
                    }
            }
        }
    }

    public var artistView: DiscogsArtistView? {
        return view as? DiscogsArtistView
    }

    public var artistModel = DiscogsArtistModel()

    // MARK: - UIViewController

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMasterRelease",
            let destination = segue.destination as? MasterReleaseViewController {
            destination.discogs = discogs

            if let selectedIndex = artistView?.indexPathForSelectedItem {
                destination.releaseSummary = artistModel.releases?[selectedIndex.item]
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        artistView?.model = artistModel

        // Clear out storyboard strings
        navigationItem.title = ""
    }

    // MARK: - Private Functions

    func fetchArtist(named artistName: String) {
        _ = discogs?.search(forArtist: artistName).done { [weak self] in
            if let results = $0.results?.filter({ $0.type == "artist" }) {
                self?.handleArtistResults(results)
            }
            }.catch { [weak self] (error) in
                self?.presentAlert(for: error)
        }
    }

    func handleArtistResults(_ results: [SearchResult]) {
        switch results.count {
        case 0:
            if let artistName = artistName {
                showNoResultsAlert(forArtistNamed: artistName)
            }
        case 1:
            artistSearchResult = results.first
        default:
            // If there's an exact match, use it.
            if let firstArtistName = results.first?.title.lowercased(),
                let artistName = artistName?.lowercased(),
                firstArtistName == artistName {
                artistSearchResult = results.first
            } else {
                showDisambiguationList(withResults: results)
            }
        }
    }

    private func showNoResultsAlert(forArtistNamed artistName: String) {
        let alert = UIAlertController(title: "No Artists Found",
                                      message: "Discogs doesn't know about any artists named \(artistName)",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
            self?.navigationController?.popViewController(animated: true)
        })

        present(alert, animated: true)
    }

    private func showDisambiguationList(withResults results: [SearchResult]) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        if let disambiguationViewController = storyboard.instantiateViewController(withIdentifier: "DiscogsDisambiguation") as? DiscogsDisambiguationViewController {
            disambiguationViewController.searchResults = results
            disambiguationViewController.artistViewController = self
            present(disambiguationViewController, animated: true)
        }
    }

    func fetchReleases() {
        guard let artistId = artist?.id else {
            return
        }

        discogs?.releases(forArtist: artistId).done { [weak self] (summaries) in
            self?.artistModel.releases = summaries.releases?.filter { $0.type == "master" && $0.mainRelease != nil }
            self?.artistView?.refresh()
            }.catch { (error) in
                // HANDLE THE ERROR
        }
    }

}
