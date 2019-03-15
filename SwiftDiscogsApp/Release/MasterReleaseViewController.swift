//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

public class MasterReleaseViewController: UIViewController, DiscogsProvider {

    // MARK: - Public Properties

    public var discogs: Discogs?

    public var masterRelease: MasterRelease? {
        get {
            return model.masterRelease
        }
        
        set {
            model.masterRelease = newValue
            tableView?.reloadData()
        }
    }

    private var model = MasterReleaseModel()

    public var releaseSummary: ReleaseSummary? {
        didSet {
            if let masterReleaseID = releaseSummary?.id {
                // Get the master release itself.
                discogs?.masterRelease(identifier: masterReleaseID).done { [weak self] (masterRelease) in
                    self?.model.masterRelease = masterRelease
                    self?.navigationItem.title = masterRelease.title
                    self?.tableView?.reloadData()
                    }.catch { (error) in
                        print("Error: \(error)")
                    }
                // Get the master release's versions. We don't have to wait for
                // the actual master release itself to be retrieved.
                discogs?.releasesForMasterRelease(masterReleaseID, pageNumber: 1, resultsPerPage: 200).done { [weak self] (releaseSummaries) in
                    self?.model.releaseVersions = releaseSummaries.versions
                    self?.tableView?.reloadData()
                    }.catch { (error) in
                        print("Error: \(error)")
                }
            }
        }
    }

    @IBOutlet private weak var tableView: UITableView?

    // MARK: - UIViewController

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSong" || segue.identifier == "playSong",
            let songViewController = segue.destination as? SongViewController,
            let row = tableView?.indexPathForSelectedRow?.row {
            songViewController.song = song(forSelectedIndex: row)
            songViewController.discogs = discogs
        } else if segue.identifier == "showReleaseVersion",
            let versionViewController = segue.destination as? ReleaseVersionViewController {
            versionViewController.masterRelease = masterRelease
            versionViewController.discogs = discogs

            if let selectedIndex = tableView?.indexPathForSelectedRow {
                versionViewController.releaseVersion = model.releaseVersions?[selectedIndex.row]
            }
        }
    }

    private func song(forSelectedIndex index: Int) -> Song? {
        if let track = model.tracks?[index] {
            return Song(title: track.title, artist: masterRelease?.artists[0].name)
        } else {
            return nil
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""  // clear out the storyboard's value
        tableView?.dataSource = model
        tableView?.delegate = model
    }

    private class MasterReleaseModel: ReleaseModel {

        // MARK: - Public Properties
        
        public var masterRelease: MasterRelease? {
            didSet {
                tracks = masterRelease?.tracklist
            }
        }
        
        public var releaseVersions: [MasterReleaseVersion]?

        // MARK: - Private Properties

        private let versionsSection = Section(cellID: "versionCell", headerText: L10n.versions)
        
        // MARK: - Initialization
        
        public override init() {
            super.init()
            sections = [tracklistSection, versionsSection]
        }
        
        // MARK: - UITableViewDataSource

        open override func tableView(_ tableView: UITableView,
                                     cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let section = sections[indexPath.section]

            if section === versionsSection {
                let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID,
                                                         for: indexPath)
                if let cell = cell as? ReleaseVersionTableCell,
                    let releaseSummary = releaseVersions?[indexPath.row] {
                    cell.setUp(with: releaseSummary)
                }

                return cell
            } else {
                return super.tableView(tableView, cellForRowAt: indexPath)
            }
        }

        public override func tableView(_ tableView: UITableView,
                                       numberOfRowsInSection sectionIndex: Int) -> Int {
            let section = sections[sectionIndex]

            if section === versionsSection {
                return releaseVersions?.count ?? 0
            } else {
                return super.tableView(tableView, numberOfRowsInSection: sectionIndex)
            }
        }
    }
    
}
