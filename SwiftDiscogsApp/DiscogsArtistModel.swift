//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// The data model for the `DiscogsArtistViewController`. It's both a table
/// view and a collection view model.
open class DiscogsArtistModel: NSObject,
                               UITableViewDataSource, UITableViewDelegate,
                               UICollectionViewDataSource, UICollectionViewDelegate {

    public enum Section: Int {
        case bio = 0
        case releases
    }

    // MARK: - Properties

    open var artist: DiscogsArtist

    fileprivate let bundle = Bundle(for: DiscogsArtistModel.self)

    // MARK: - Initializers

    public init(artist: DiscogsArtist) {
        self.artist = artist
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate

    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }

    open func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }

    open func tableView(_ tableView: UITableView,
                        titleForHeaderInSection section: Int) -> String? {
        return headerTitle(forSection: section)
    }

    // MARK: - UICollectionViewDataSource & UICollectionViewDelegate

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: CGRect())
    }

    open func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }

    // MARK: - Other Functions

    fileprivate func numberOfItems(inSection section: Int) -> Int {
        guard let sectionCase = Section(rawValue: section) else {
            return 0
        }

        switch sectionCase {
        case .bio:
            return 1
        case .releases:
            return 0 // discogsArtist
        }
    }

    fileprivate func numberOfSections() -> Int {
        return Section.releases.rawValue + 1
    }

    fileprivate func headerTitle(forSection section: Int) -> String? {
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
