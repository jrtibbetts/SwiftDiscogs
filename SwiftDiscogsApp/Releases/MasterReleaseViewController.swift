//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

public class MasterReleaseViewController: UITableViewController, DiscogsProvider {

    // MARK: - Public Properties

    public var discogs: Discogs?

    public var masterRelease: MasterRelease? {
        get {
            return model.masterRelease
        }
        
        set {
            model.masterRelease = masterRelease
        }
    }

    public var releaseSummary: ReleaseSummary? {
        didSet {
            if let masterReleaseID = releaseSummary?.id {
                // Get the master release itself.
                discogs?.masterRelease(identifier: masterReleaseID).done { [weak self] (masterRelease) in
                    self?.model.masterRelease = masterRelease
                    self?.navigationItem.title = masterRelease.title
                    self?.tableView.reloadData()
                    }.catch { (error) in
                        print("Error: \(error)")
                    }
                // Get the master release's versions. We don't have to wait for
                // the actual master release itself to be retrieved.
                discogs?.releasesForMasterRelease(masterReleaseID, pageNumber: 1, resultsPerPage: 200).done { [weak self] (releaseSummaries) in
                    self?.model.releaseVersions = releaseSummaries.versions
                    self?.tableView.reloadData()
                    }.catch { (error) in
                        print("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var model: Model = Model()
    
    // MARK: - UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = model
    }

    private class Model: SectionedModel {

        // MARK: - Public Properties
        
        public var masterRelease: MasterRelease?
        
        public var releaseVersions: [MasterReleaseVersion]?

        // MARK: - Private Properties

        private let tracklistSection = Section(cellID: "trackCell", headerText: L10n.tracklist)

        private let versionsSection = Section(cellID: "versionCell", headerText: L10n.versions)
        
        // MARK: - Initialization
        
        public init() {
            super.init(sections: [tracklistSection, versionsSection])
        }
        
        // MARK: - UITableViewDataSource

        open override func tableView(_ tableView: UITableView,
                                     cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let section = sections[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID,
                                                     for: indexPath)

            if section === tracklistSection {
                if let cell = cell as? TracklistTableCell,
                    let track = masterRelease?.tracklist[indexPath.row] {
                    cell.setUp(with: track)
                }
            } else if section === versionsSection {
                if let cell = cell as? ReleaseVersionTableCell,
                    let releaseSummary = releaseVersions?[indexPath.row] {
                    cell.setUp(with: releaseSummary)
                }
            }

            return cell
        }

        public override func tableView(_ tableView: UITableView,
                                       numberOfRowsInSection sectionIndex: Int) -> Int {
            let section = sections[sectionIndex]

            if section === tracklistSection {
                return masterRelease?.tracklist.count ?? 0
            } else if section === versionsSection {
                return releaseVersions?.count ?? 0
            } else {
                return 0
            }
        }
    }
    
}
