//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

/// The data model for the `DiscogsArtistViewController`. It's both a table
/// view and a collection view model.
open class DiscogsArtistModel: CollectionAndTableModel {

    public enum Section: Int {
        case bio = 0
        case releases

        var cellIdentifier: String {
            switch self {
            case .bio:
                return "artistBioCell"
            case .releases:
                return "artistAlbumCell"
            }
        }

    }

    // MARK: Public Properties

    open var artist: DiscogsArtist?

    open var releases: [DiscogsReleaseSummary]? {
        didSet {

        }
    }

    // MARK: Private Properties

    fileprivate var thumbnails: [UIImage?]?

    fileprivate let bundle = Bundle(for: DiscogsArtistModel.self)

    // MARK: Initializers

    /// This is required for associated objects that are loaded by Interface
    /// Builder.
    override public init() {
        super.init()
    }
    
    public init(artist: DiscogsArtist? = nil) {
        self.artist = artist
        super.init()
    }

    // MARK: UITableViewDataSource

    open override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }

        switch section {
        case .bio:
            if let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier) as? DiscogsArtistBioTableCell {
                cell.bioText = artist?.profile

                return cell
            }
        case .releases:
            let row = indexPath.row
            let releaseSummary = releases?[row]

            if let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier) as? DiscogsArtistReleaseTableCell {
                cell.thumbnail = thumbnails?[row]
                cell.title = releaseSummary?.title
                cell.year = releaseSummary?.year

                return cell
            }
        }


        return super.tableView(tableView, cellForRowAt: indexPath)
    }

    // MARK: - Model

    open override func numberOfItems(inSection section: Int) -> Int {
        guard let sectionCase = Section(rawValue: section) else {
            return 0
        }

        switch sectionCase {
        case .bio:
            return 1
        case .releases:
            return releases?.count ?? 0
        }
    }

    open override func numberOfSections() -> Int {
        return Section.releases.rawValue + 1
    }

    open override func headerTitle(forSection section: Int) -> String? {
        guard let sectionCase = Section(rawValue: section) else {
            return nil
        }

        switch sectionCase {
        case .bio:
            return NSLocalizedString("artistBioSectionHeader",
                                     tableName: nil,
                                     bundle: bundle,
                                     value: "Bio",
                                     comment: "Title of the artist's biography section")
        case .releases:
            return NSLocalizedString("artistReleasesSectionHeader",
                                     tableName: nil,
                                     bundle: bundle,
                                     value: "Releases",
                                     comment: "Title of the artist's releases section")
        }
    }

}
