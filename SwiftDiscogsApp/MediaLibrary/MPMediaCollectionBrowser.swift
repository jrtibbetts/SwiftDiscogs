//  Copyright © 2017 nrith. All rights reserved.

import MediaPlayer
import Medi8

/// Implemented by classes and structs that browse the `MPMediaCollection`s on
/// a device using a visitor pattern.
public protocol MPMediaCollectionBrowser {

    /// Start browsing a media collection with a media query. A default
    /// implementation is provided to iterate over the collection's media
    /// item collections, so implementors probably shouldn't implement this
    /// themselves.
    ///
    /// - parameter startingWith query: The media query to start with.
    func browse(startingWith query: MPMediaQuery)

    /// Process a `MPMediaItemCollection`.
    ///
    /// - parameter mediaCollection: The collection. Implementors should not
    /// iterate over the collection's contents; they should simply inspect the
    /// collection's attributes.
    /// - parameter at index: The index of the collection in the starting media
    /// query's results.
    func inspect(_ mediaCollection: MPMediaItemCollection, at index: Int)

    /// Process a `MPMediaItem`.
    ///
    /// - parameter mediaItem: The media item.
    /// - parameter at index: The index of the item in its collection.
    func inspect(_ mediaItem: MPMediaItem, at index: Int)

    /// An object that wants to keep track of the browser's progress.
    var delegate: MPMediaCollectionBrowserDelegate? { get set }

}

public extension MPMediaCollectionBrowser {

    func browse(startingWith query: MPMediaQuery) {
        delegate?.willStartImporting()

        if let collections = query.collections {
            let totalCount = collections.count
            collections.enumerated().forEach({ (__val:(Int, MPMediaItemCollection)) in let (index,collection) = __val; 
                do {
                    inspect(collection, at: index)
                    delegate?.willInspect(mediaCollection: collection, at: index, outOf: totalCount)

                    let totalItemCount = collection.items.count
                    collection.items.enumerated().forEach({ (__val:(Int, MPMediaItem)) in let (index,item) = __val; 
                        delegate?.willInspect(mediaItem: item, at: index, outOf: totalItemCount)
                        inspect(item, at: index)
                    })
                }
            })
        }

        delegate?.didFinishImporting(with: nil)
    }

}

/// Implemented by classes and structs that want to keep track of the progress
/// of the collection browser. The browser should ensure that delegate methods
/// are called on the main thread, but this is not guaranteed.
public protocol MPMediaCollectionBrowserDelegate: MediaImporterDelegate {

    /// Called when a media collection is about to be inspected.
    ///
    /// - parameter mediaCollection: The `MPMediaItemCollection` that's about
    /// to be inspected.
    /// - parameter at index: The collection's position in the array of all
    /// collections.
    /// - parameter outOf total: The total number of collections.
    func willInspect(mediaCollection: MPMediaItemCollection, at index: Int, outOf total: Int)

    /// Called when a media item is about to be inspected.
    ///
    /// - parameter mediaItem: The `MPMediaItem` that's about to be inspected.
    /// - parameter at index: The item's position in the array of its parent
    /// collection's items.
    /// - parameter outOf total: The total number of items *in the `mediaItem`'s
    /// collection*.
    func willInspect(mediaItem: MPMediaItem, at index: Int, outOf total: Int)

}

