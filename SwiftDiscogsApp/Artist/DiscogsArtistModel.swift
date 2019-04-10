//  Copyright © 2018 Poikile Creations. All rights reserved.

import Kingfisher
import Stylobate
import SwiftDiscogs
import UIKit

/// The data model for the `DiscogsArtistViewController`. It's both a table
/// view and a collection view model.
open class DiscogsArtistModel: SectionedModel {

    // MARK: Public Properties

    open var artist: Artist?

    open var releases: [ReleaseSummary]? {
        didSet {
            releasesSection.releases = releases
        }
    }
    
    // MARK: Private Properties

    private var bioSection = BioSection(cellID: "artistBioCell",
                                        headerText: L10n.artistBioSectionHeader)
    private var releasesSection = ReleaseSection(cellID: "artistAlbumCell",
                                                 headerText: L10n.artistReleasesSectionHeader)
    // MARK: Initializers

    public override init() {
        super.init(sections: [bioSection, releasesSection])
    }

    // MARK: - UITableViewDataSource

    open override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID,
                                                 for: indexPath)

        if section === bioSection {
            bioSection.configure(cell: cell, forArtist: artist)
        } else if section === releasesSection {
            releasesSection.configure(cell: cell, forReleaseIndex: indexPath.row)
        }

        return cell
    }

    // MARK: - CollectionAndTableModel

    open override func numberOfItems(inSection sectionIndex: Int) -> Int {
        return sections[sectionIndex].numberOfItems ?? 0
    }

    class BioSection: Section {

        func configure(cell: UITableViewCell,
                       forArtist artist: Artist?) {
            if let cell = cell as? DiscogsArtistBioTableCell {
                cell.bioText = artist?.profile
            }
        }

        override var numberOfItems: Int? {
            return 1
        }

    }

    class ReleaseSection: Section {

        var releases: [ReleaseSummary]?

        override var numberOfItems: Int? {
            return releases?.count ?? super.numberOfItems
        }

        func configure(cell: UITableViewCell,
                       forReleaseIndex releaseIndex: Int) {
            let releaseSummary = releases?[releaseIndex]

            if let cell = cell as? DiscogsArtistReleaseTableCell {
                cell.summary = releaseSummary
            }
        }
    }

}
