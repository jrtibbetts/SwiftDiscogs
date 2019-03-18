//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

// MARK: - Private Properties

public class BaseReleaseViewController: UIViewController, DiscogsProvider {

    // MARK: - Public Properties

    public var discogs: Discogs? = DiscogsClient.singleton

    // MARK: - Public Properties

    public var masterRelease: MasterRelease? {
        get {
            return model?.masterRelease
        }

        set {
            model?.masterRelease = newValue
            connect()
        }
    }

    public var model: ReleaseModel? {
        didSet {
            connect()
        }
    }

    // MARK: - Outlets

    @IBOutlet public weak var display: CoverArtAndTableView? {
        didSet {
            connect()
        }
    }

    private func connect() {
        display?.model = model
        display?.refresh()
    }

    // MARK: - UIViewController

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSong" || segue.identifier == "playSong",
            let songViewController = segue.destination as? SongViewController,
            let row = display?.tableView?.indexPathForSelectedRow?.row {
            songViewController.song = song(forSelectedIndex: row)
            songViewController.discogs = discogs
        } else {
            return super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: - Other Functions

    private func song(forSelectedIndex index: Int) -> Song? {
        if let track = model?.tracks?[index] {
            return Song(title: track.title, artist: masterRelease?.artists[0].name)
        } else {
            return nil
        }
    }

}
