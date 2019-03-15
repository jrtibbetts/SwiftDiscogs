//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
@testable import SwiftDiscogsApp
import Stylobate
import XCTest

class SongTests: XCTestCase {

    func testSongModelWithNoSongHasNoSections() {
        XCTAssertEqual(SongModel().sections.count, 0)
    }

    func testSongModelNumberOfItemsWithNegativeSectionIs0() {
        XCTAssertEqual(SongModel().numberOfItems(inSection: -33), 0)
    }

    func testSongModelNumberOfItemsWithHighSectionIs0() {
        XCTAssertEqual(SongModel().numberOfItems(inSection: 33), 0)
    }

    func testSongWithTwoVersionsOk() {
        XCTAssertEqual(SongTests.songWithTwoVersions.versions.count, 2)
    }

    func testSongWith1PersonOk() {
        XCTAssertNotNil(SongTests.songWithTwoVersions.personnel)
        XCTAssertEqual(SongTests.songWithTwoVersions.personnel!.count, 1)
    }

    func testSongModelWithTwoVersionsHasAVersionsSection() {
        let model = SongModel()
        model.song = SongTests.songWithTwoVersions
        XCTAssertTrue(model.sections.contains(model.songTitleSection),
                      "Has sections \(model.sections)")
        XCTAssertTrue(model.sections.contains(model.personnelSection),
                      "Has sections \(model.sections)")
        XCTAssertTrue(model.sections.contains(model.versionsSection),
                       "Has sections \(model.sections)")
        XCTAssertEqual(model.sections.count, 3,
                       "Should have title, personnel, and versions sections; has \(model.sections)")
    }

    func testSongModelWithTwoVersionsHasExpectedItemCountsPerSection() {
        let model = SongModel()
        model.song = SongTests.songWithTwoVersions
        XCTAssertEqual(model.numberOfItems(inSection: 0), 1)  // title
        XCTAssertEqual(model.numberOfItems(inSection: 1), 1)  // personnel
        XCTAssertEqual(model.numberOfItems(inSection: 2), 2)  // versions
    }

    static var songWithTwoVersions: Song = {
        let songJSON = """
{
    "id": 99910009,
    "artist": "Wings",
    "artwork": "https://img.discogs.com/discogs-images/R-6928296-1513269118-8771.jpeg.jpg",
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
        return try! JSONUtils.jsonObject(data: songJSON.data(using: .utf8)!)
    }()

    func testSongWithNoVersionsOk() {
        XCTAssertEqual(SongTests.songWithNoVersions.versions.count, 0)
    }

    func testSongModelWithNoVersionsHasNoVersionsSection() {
        let model = SongModel()
        model.song = SongTests.songWithNoVersions
        XCTAssertTrue(model.sections.contains(model.songTitleSection),
                      "Has sections \(model.sections)")
        XCTAssertTrue(model.sections.contains(model.personnelSection),
                      "Has sections \(model.sections)")
        XCTAssertFalse(model.sections.contains(model.versionsSection),
                       "Has sections \(model.sections)")
        XCTAssertEqual(model.sections.count, 2,
                       "Should have title and personnel sections; has \(model.sections)")
    }

    func testSongModelWithNoVersionsHasExpectedItemCountsPerSection() {
        let model = SongModel()
        model.song = SongTests.songWithTwoVersions
        XCTAssertEqual(model.numberOfItems(inSection: 0), 1)  // title
        XCTAssertEqual(model.numberOfItems(inSection: 1), 1)  // personnel
    }

    static var songWithNoVersions: Song = {
        let songJSON = """
{
    "id": 99910009,
    "artist": "Wings",
    "artwork": "https://img.discogs.com/discogs-images/R-6928296-1513269118-8771.jpeg.jpg",
    "personnel": [
        {
            "name": "Paul McCartney",
            "roles": ["lead vocals", "bass guitar", "drums", "synthesizer"]
        }
    ],
    "title": "With a Little Luck",
    "versions": [ ]
}
"""
        return try! JSONUtils.jsonObject(data: songJSON.data(using: .utf8)!)
    }()

}
