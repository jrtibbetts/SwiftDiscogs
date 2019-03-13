//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation
import SwiftDiscogs

open class Song: NSObject, Codable {

    open var artist: String?

    open var id: Int

    open var lyrics: String?

    open var personnel: [Performer]?
    
    open var title: String

    open var versions: [Version]

    open class Performer: NSObject, Codable {

        open var name: String

        open var roles: [String]

    }

    open class Version: NSObject, Codable {

        open var alternateTitle: String?

        open var disambiguationNote: String?

        open var duration: TimeInterval?

    }

}

let songJSON = """
{
    "id": 99910009,
    "artist": "Wings",
    "personnel": [
        {
            "name": "Paul McCartney",
            "roles": ["lead vocals", "bass guitar", "drums", "synthesizer"]
        }
    ],
    "title": "With a Little Luck",
    "versions": [
        {
            "disambiguation_note": "DJ edit",
            "duration": 195.0
        },
        {
            "disambiguation_note": "album version",
            "duration": 347.0
        },
    ]
}
"""
