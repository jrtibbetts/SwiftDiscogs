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
