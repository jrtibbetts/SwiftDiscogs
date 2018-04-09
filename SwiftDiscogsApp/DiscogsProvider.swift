//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs

/// Implemented by view controllers and other classes that hold a reference to
/// the discogs client.
public protocol DiscogsProvider {

    var discogs: Discogs? { get set }

}
