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
            if let cell = cell as? TracklistTableCell {
                cell.track = masterRelease?.tracklist[indexPath.row]
            }
        } else if section === versionsSection {
            if let cell = cell as? ReleaseVersionTableCell,
                let releaseSummary = releaseVersions?[indexPath.row] {
                cell.release = releaseSummary
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

public class TracklistTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var durationLabel: UILabel?
    @IBOutlet public weak var titleLabel: UILabel?
    @IBOutlet public weak var trackNumberLabel: UILabel?

    // MARK: - Properties

    public var track: Track? {
        didSet {
            durationLabel?.text = track?.duration
            titleLabel?.text = track?.title
            trackNumberLabel?.text = track?.position
        }
    }

}

public class ReleaseVersionTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var titleLabel: UILabel?

    // MARK: - Properties

    public var release: MasterReleaseVersion? {
        didSet {
            guard let release = release else {
                return
            }

            titleLabel?.text = release.title

            var text = release.majorFormats?.joined(separator: " ").appending(" ") ?? ""

            if let country = release.country {
                text.append("\(country) ")
            }

            if let label = release.label {
                text.append("\(label) ")
            }

            if let catalogNumber = release.catno?.split(separator: ",").first {
                text.append(String(catalogNumber))
            }

            titleLabel?.text = text
        }
    }

}
