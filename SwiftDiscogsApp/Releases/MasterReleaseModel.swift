//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

public class MasterReleaseModel: SectionedModel {

    // MARK: - Public Properties

    public var masterRelease: MasterRelease?

    public var releaseSummaries: [ReleaseSummary]?

    // MARK: - Private Properties

    private let releasesSection = Section(cellID: "releaseCell", headerText: "All Releases")

    private let tracklistSection = Section(cellID: "trackCell", headerText: "Tracklist")

    // MARK: - Initializers

    public init() {
        super.init(sections: [releasesSection, tracklistSection])
    }

    // MARK: - UITableViewDataSource

    open override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID,
                                                 for: indexPath)

        if section === tracklistSection {
            if let cell = cell as? TracklistTableCell {
                cell.track = masterRelease?.tracklist[indexPath.row]
            }
        } else if section === releasesSection {
            if let cell = cell as? ReleaseTableCell,
                let releaseSummary = releaseSummaries?[indexPath.row] {
                cell.release = releaseSummary
            }
        }

        return cell
    }

    // MARK: - CollectionAndTableModel

    open override func numberOfItems(inSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]

        if section === tracklistSection {
            return masterRelease?.tracklist.count ?? 0
        } else if section === releasesSection {
            return releaseSummaries?.count ?? 0
        } else {
            return 0
        }
    }

}
