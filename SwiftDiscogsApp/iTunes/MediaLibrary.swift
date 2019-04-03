//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer
import PromiseKit

public protocol MediaLibrary {

    func artists(named: String?) -> [MPMediaItem]?

    func songs(named: String?) -> [MPMediaItem]?

}

public struct iTunesMediaLibrary: MediaLibrary {

    public func artists(named artistName: String? = nil) -> [MPMediaItem]? {
        let query = MPMediaQuery.artists()

        if let artistName = artistName {
            let predicate = MPMediaPropertyPredicate(value: artistName,
                                                     forProperty: MPMediaItemPropertyArtist,
                                                     comparisonType: .contains)
            query.addFilterPredicate(predicate)
        }

        return query.items
    }

    public func songs(named songName: String? = nil) -> [MPMediaItem]? {
        let query = MPMediaQuery.songs()
        let predicate = MPMediaPropertyPredicate(value: songName,
                                                 forProperty: MPMediaItemPropertyTitle,
                                                 comparisonType: .contains)
        query.addFilterPredicate(predicate)

        return query.items
    }

}
