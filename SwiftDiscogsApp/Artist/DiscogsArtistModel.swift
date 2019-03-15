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

    open var releases: [ReleaseSummary]?
    
    // MARK: Private Properties

    private var bioSection = Section(cellID: "artistBioCell",
                                     headerText: L10n.artistBioSectionHeader)
    private var releasesSection = Section(cellID: "artistAlbumCell",
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
            if let cell = cell as? DiscogsArtistBioTableCell {
                cell.bioText = artist?.profile
            }
        } else if section === releasesSection {
            let row = indexPath.row
            let releaseSummary = releases?[row]

            if let cell = cell as? DiscogsArtistReleaseTableCell {
                cell.summary = releaseSummary
            }
        }

        return cell
    }

    // MARK: - CollectionAndTableModel

    open override func numberOfItems(inSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]

        if section === bioSection {
            return 1
        } else if section === releasesSection {
            return releases?.count ?? 0
        } else {
            return 0
        }
    }

    // MARK: - Private Functions

    private func fetchThumbnails() {
        artist?.images?.forEach { (imageData) in
            if let url = URL(string: imageData.resourceUrl) {
                KingfisherManager.shared.retrieveImage(with: url,
                                                       completionHandler: { (result) in
                                                        if result.isSuccess {
                                                            print("Successfully got image \(imageData.resourceUrl)")
                                                        }
                })
            }
        }
    }

}
