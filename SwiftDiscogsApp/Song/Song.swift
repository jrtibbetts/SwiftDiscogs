//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation
import SwiftDiscogs

open class Song: NSObject, Codable {

    open var artist: ArtistSummary

    open var id: Int

    open var lyrics: String?

    open var personnel: [Performer]?
    
    open var title: String

    open var versions: [Version]

    open class Performer: NSObject, Codable {

        open var name: String

        open var roles: [Role]

    }

    open class Role: NSObject, Codable {

        open var name: String

    }

    open class Version: NSObject, Codable {

        open var alternateTitle: String?

        open var disambiguationNote: String?

        open var duration: TimeInterval?

    }

}
