//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// The model for the `SongViewController`.
open class SongModel: SectionedModel {

    /// The song. Setting it also sets up the model's sections. If it's `nil`,
    /// then no sections are added. If it's not, the `songTitleSection` is
    /// added first, followed by the personnel, lyrics, and/or versions
    /// sections, depending on whether those are present.
    open var song: Song? {
        didSet {
            guard let song = song else {
                sections = []
                return
            }

            var activeSections = [songTitleSection]

            if let personnel = song.personnel, !personnel.isEmpty {
                activeSections.append(personnelSection)
            }

            if song.lyrics != nil {
                activeSections.append(lyricsSection)
            }

            if !song.versions.isEmpty {
                activeSections.append(versionsSection)
            }

            sections = activeSections
        }
    }

    open var lyricsSection = Section(cellID: "lyricsCell", headerText: L10n.lyrics)
    open var personnelSection = Section(cellID: "personnelCell", headerText: L10n.personnel)
    open var songTitleSection = Section(cellID: "songTitleCell", headerText: nil)
    open var versionsSection = Section(cellID: "songVersionCell", headerText: L10n.versions)

    // MARK: - CollectionAndTableModel

    /// Get the item count for a given section.
    ///
    /// - parameter sectionIndex: The section's index. The `sections` list is
    ///             set up when the `song` is set.
    ///
    /// - returns `1` if the section is for lyrics or the song title, the
    ///           number of personnel or versions (if any), or 0 if `song` is
    ///           `nil` or the index is out of bounds.
    open override func numberOfItems(inSection sectionIndex: Int) -> Int {
        if sections.isEmpty
            || sectionIndex < 0
            || sectionIndex >= sections.count {
            return 0
        }
        let section = sections[sectionIndex]

        switch section {
        case lyricsSection, songTitleSection:
            return 1
        case personnelSection:
            return song?.personnel?.count ?? 0
        case versionsSection:
            return song?.versions.count ?? 0
        default:
            return 0
        }
    }

    // MARK: - UITableViewDataSource

    open override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = sections[indexPath.section].cellID
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        switch sections[indexPath.section] {
        case lyricsSection:
            (cell as? SongLyricsTableViewCell)?.song = song
        case personnelSection:
            (cell as? SongCreditsTableViewCell)?.performer = song?.personnel?[indexPath.row]
        case songTitleSection:
            (cell as? SongNameTableViewCell)?.song = song
        case versionsSection:
            (cell as? SongVersionTableViewCell)?.songVersion = song?.versions[indexPath.row]
        default:
            break
        }

        return cell
    }

}
