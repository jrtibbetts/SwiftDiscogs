//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

/// The user interface for the `DiscogsArtistViewController`. It has outlets
/// for a table view and a collection view, even though only one will be
/// active at a time, depending on the device's orientation.
open class DiscogsArtistView: CollectionAndTableDisplay {

}

public protocol DiscogsArtistBioCell {

    var bioLabel: UILabel? { get }
    var bioText: String? { get set }

}

open class DiscogsArtistBioTableCell: UITableViewCell, DiscogsArtistBioCell {

    @IBOutlet open weak var bioLabel: UILabel?

    open var bioText: String? {
        set {
            bioLabel?.text = bioText
        }

        get {
            return bioLabel?.text
        }
    }

}
