//  Copyright © 2017 nrith. All rights reserved.

import CoreData
import MediaPlayer
import Medi8
import Stylobate

/// A media collection browser that populates a core data context as it
/// inspects the items in a collection.
public class MPMediaItemCollectionImporter: MediaImporter, MPMediaCollectionBrowser {

    public var browserDelegate: MPMediaCollectionBrowserDelegate?

    public var artistCount: Int = 0

    public var releaseCount: Int = 0

    public var songCount: Int = 0

    private let mediaQuery: MPMediaQuery

    public init(context: NSManagedObjectContext, mediaQuery: MPMediaQuery) {
        self.mediaQuery = mediaQuery
        super.init()
        self.context = context
    }

    public func importMedia() throws {
        browse(startingWith: mediaQuery)
    }

    public func inspect(_ collection: MPMediaItemCollection, at index: Int) {
    }

    public func inspect(_ mediaItem: MPMediaItem, at index: Int) {
        guard let artistName = mediaItem.artist,
            let releaseTitle = mediaItem.albumTitle,
            let songName = mediaItem.title else {
                return
        }

        do {
            let artist = try fetchOrCreateArtist(named: artistName)!
            let masterRelease = try fetchOrCreateMasterRelease(named: releaseTitle, by: [artist], releaseDate: mediaItem.releaseDate)!
            let song = try fetchOrCreateSong(named: songName, by: artist)!

            if let mediaItemLyrics = mediaItem.lyrics {
                let lyrics = Lyrics(context: context)
                lyrics.text = mediaItemLyrics
                song.lyrics = lyrics
            }

            let songVersion = SongVersion(context: context) <~ {
                $0.localUrlString = mediaItem.assetURL?.absoluteString
                $0.duration = String(mediaItem.playbackDuration)
                $0.notes = mediaItem.comments
            }

//        let trackNumber = mediaItem.albumTrackNumber

            masterRelease.versions?.forEach { (v) in
                if let version = v as? ReleaseVersion {
                    version.trackListing?.addToSongVersions(songVersion)
                }
            }

            print("\(artistName) \"\(songName)\" (from \(releaseTitle))")
        } catch {
            print("Error: \(error)")
        }
    }
}
