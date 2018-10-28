//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs

/// Implemented by view controllers and other classes that hold a reference to
/// the discogs client. Sometimes it's easiest to implement `prepareForSegue()`
/// not by casting the `destination` to an expected view controller type, but
/// just to `DiscogsProvider`, so that the `Discogs` reference can be passed
/// around without all users of it having to get a global instance themselves.
public protocol DiscogsProvider {

    var discogs: Discogs? { get set }

}
