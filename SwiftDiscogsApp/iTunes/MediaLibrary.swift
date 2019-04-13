//  Copyright © 2019 Poikile Creations. All rights reserved.

import MediaPlayer

/// Provides access to the `MPMediaItem`s and other `MediaPlayer` elements on
/// the user's device.
public protocol MediaLibrary {

    /// Get all on-device media items by artists whose names contain the
    /// specified string.
    ///
    /// - parameter named: The artist's name. If it's `nil`, then all items on
    ///             the device will be returned.
    ///
    /// - returns: The media items containing the specified artist.
    func artists(named: String?) -> [MPMediaItem]?

    /// Get all on-device songs that contain the specified name.
    ///
    /// - parameter named: The song's name. If it's `nil`, then all items on
    ///             the device will be returned.
    ///
    /// - returns: The media items containing the specified name.
    func songs(named: String?) -> [MPMediaItem]?

    /// Get all on-device songs that are by the specified artist.
    ///
    /// - parameter named: The artist's name. If it's `nil`, then all items on
    ///             the device will be returned.
    ///
    /// - returns: The media items by the specified artist.
    func songs(byArtistNamed: String?) -> [MPMediaItem]?

}

public struct MediaLibraryManager {

    public static var mediaLibrary: MediaLibrary = iTunesMediaLibrary()

}
