//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

open class SongViewController: UIViewController, DiscogsProvider {

    // MARK: - Public Properties

    open var songDisplay: SongView? {
        return view as? SongView
    }

    open var model = SongModel()

    // MARK: - DiscogsProvider

    public var discogs: Discogs? = DiscogsClient.singleton

    // MARK: - UIViewController

    open override func viewDidLoad() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            if let data = songJSON.data(using: .utf8) {
                model.song = try decoder.decode(Song.self, from: data)
            }
        } catch {

        }

        songDisplay?.model = model
    }

}

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
            if let cell = cell as? SongLyricsTableViewCell {
                cell.lyricsLabel.text = song?.lyrics
            }
        case personnelSection:
            if let cell = cell as? SongCreditsTableViewCell,
                let performer = song?.personnel?[indexPath.row] {
                cell.playerNameButton.titleLabel?.text = performer.name
                cell.roleLabel.text = performer.roles.joined(separator: ", ")
            }
        case songTitleSection:
            if let cell = cell as? SongNameTableViewCell {
                cell.songNameLabel.text = song?.title
            }
        case versionsSection:
            if let cell = cell as? SongVersionTableViewCell,
                let version = song?.versions[indexPath.row] {

                if let disambiguation = version.disambiguationNote {
                    cell.differentiationLabel.isHidden = false
                    cell.differentiationLabel.text = disambiguation
                } else {
                    cell.differentiationLabel.isHidden = true
                }

                cell.durationLabel.text = "\((version.duration ?? 0) / 1000)" // this should be formatted as a time
            }
        default:
            break
        }

        return cell
    }

}
