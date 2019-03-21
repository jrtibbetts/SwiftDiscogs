//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs

public class ReleaseModel: SectionedModel {

    // MARK: - Public Properties

    public var masterRelease: MasterRelease? {
        didSet {
            tracks = masterRelease?.tracklist
        }
    }
    
    public var tracks: [Track]?

    public let tracklistSection = Section(cellID: "trackCell", headerText: L10n.tracklist)

    // MARK: - UITableViewDataSource

    open override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID,
                                                 for: indexPath)

        if section === tracklistSection {
            if let cell = cell as? TrackTableCell,
                let track = tracks?[indexPath.row] {
                cell.setUp(with: track)
            }
        }

        return cell
    }

    public override func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]

        if section === tracklistSection {
            return tracks?.count ?? 0
        } else {
            return 0
        }
    }
}

