//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

open class SongModel: SectionedModel {

    open var song: Song? {
        didSet {
            var activeSections = [songTitleSection]

            if song?.lyrics != nil {
                activeSections.append(lyricsSection)
            }

            if song?.versions != nil {
                activeSections.append(versionsSection)
            }

            sections = activeSections
        }
    }

    open var lyricsSection = Section(cellID: "lyricsCell", headerText: "Lyrics")
    open var personnelSection = Section(cellID: "personnelCell", headerText: "Personnel")
    open var songTitleSection = Section(cellID: "songTitleCell", headerText: nil)
    open var versionsSection = Section(cellID: "songVersionCell", headerText: "Versions")

    // MARK: - CollectionAndTableModel

    open override func numberOfItems(inSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]

        switch section {
        case lyricsSection, songTitleSection:
            return 1
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
