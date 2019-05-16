//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer

public struct iTunesMediaLibrary: MediaLibrary {

    public func albums(byArtistNamed artistName: String?) -> [MPMediaItemCollection]? {
        let query = MPMediaQuery.artists()
        query.groupingType = .album

        return query.filteredBy(MPMediaItemPropertyArtist.predicate(containing: artistName))
            .collections
    }

    public func artists(named artistName: String? = nil) -> [MPMediaItem]? {
        return MPMediaQuery.artists()
            .filteredBy(MPMediaItemPropertyArtist.predicate(containing: artistName))
            .items
    }

    public func songs(named songName: String? = nil) -> [MPMediaItem]? {
        return MPMediaQuery.songs()
            .filteredBy(MPMediaItemPropertyTitle.predicate(containing: songName))
            .items
    }

    public func songs(byArtistNamed artistName: String?) -> [MPMediaItem]? {
        return MPMediaQuery.songs()
            .filteredBy(MPMediaItemPropertyArtist.predicate(containing: artistName))
            .items
    }

    public func songs(byAlbumArtistNamed artistName: String?) -> [MPMediaItem]? {
        return MPMediaQuery.songs()
            .filteredBy(MPMediaItemPropertyAlbumArtist.predicate(containing: artistName))
            .items
    }

    public func songs(byArtistAndAlbumArtistNamed artistName: String?) -> [MPMediaItem]? {
        let songsByArtist = songs(byArtistNamed: artistName)
        let songsByAlbumArtist = songs(byAlbumArtistNamed: artistName)

        if let songsByArtist = songsByArtist, let songsByAlbumArtist = songsByAlbumArtist {
            return songsByArtist + songsByAlbumArtist
        } else if songsByArtist != nil {
            return songsByArtist
        } else if songsByAlbumArtist != nil {
            return songsByAlbumArtist
        } else {
            return nil
        }
    }

}

private extension MPMediaQuery {

    func filteredBy(_ predicate: MPMediaPredicate?) -> MPMediaQuery {
        if let predicate = predicate {
            self.addFilterPredicate(predicate)
        }

        return self
    }

}

private extension String {

    func predicate(equalTo value: String?) -> MPMediaPropertyPredicate? {
        if let value = value {
            return MPMediaPropertyPredicate(value: value, forProperty: self)
        } else {
            return nil
        }
    }

    func predicate(containing value: String?) -> MPMediaPropertyPredicate? {
        if let value = value {
            return MPMediaPropertyPredicate(value: value,
                                            forProperty: self,
                                            comparisonType: .contains)
        } else {
            return nil
        }
    }

}
