//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

public class MasterReleaseViewController: UITableViewController, DiscogsProvider {

    // MARK: - Public Properties

    public var discogs: Discogs?

    public var masterRelease: MasterRelease? {
        didSet {
            if let masterReleaseID = masterRelease?.id {
                discogs?.releasesForMasterRelease(masterReleaseID, pageNumber: 1, resultsPerPage: 200).done { [weak self] (releaseSummaries) in
                    self?.releaseVersions = releaseSummaries.versions
                    self?.tableView.reloadData()
                    }.catch { (error) in
                        print("Error: \(error)")
                }
            }
        }
    }

    public var releaseSummary: ReleaseSummary? {
        didSet {
            if let masterReleaseID = releaseSummary?.id {
                _ = discogs?.masterRelease(identifier: masterReleaseID).done { [weak self] (masterRelease) in
                    self?.masterRelease = masterRelease
                    self?.tableView.reloadData()
                    self?.navigationItem.title = masterRelease.title
                    }.catch { (error) in
                        print("Error: \(error)")
                    }
            }
        }
    }

    open class Section: NSObject {

        open var cellID: String

        open var headerText: String? = nil

        public init(cellID: String,
                    headerText: String? = nil) {
            self.cellID = cellID
            self.headerText = headerText
        }

    }

    public var releaseVersions: [MasterReleaseVersion]?

    // MARK: - Private Properties

    private let tracklistSection = Section(cellID: "trackCell", headerText: "Tracklist")

    private let versionsSection = Section(cellID: "versionCell", headerText: "All Releases")

    private var sections: [Section] {
        return [tracklistSection, versionsSection]
    }
    
    // MARK: - UITableViewDataSource

    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerText
    }

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

    // MARK: - UITableViewDataSource

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
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
