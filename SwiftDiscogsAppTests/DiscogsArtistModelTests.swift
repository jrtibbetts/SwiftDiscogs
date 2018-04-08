//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
@testable import SwiftDiscogsApp
import PromiseKit
import XCTest

class DiscogsArtistModelTests: XCTestCase {

    var discogsClient = MockDiscogs()

    lazy var artist: DiscogsArtist = {
        let url = URL(string: "http://www.cnn.com")!
        return DiscogsArtist(dataQuality: nil, id: 99, images: nil, members: nil, name: "foo", namevariations: nil, profile: nil, releasesUrl: url, resourceUrl: "", urls: nil)
    }()

    func testInitializerWithArtist() {
        _ = discogsClient.artist(identifier: 99).then { (artist) -> Void in
            let model = DiscogsArtistModel(artist: artist)
            XCTAssertEqual(model.artist.id, 108713)
        }
    }

    func testTableViewNumberOfSectionsIs2() {
        let model = DiscogsArtistModel(artist: artist)
        XCTAssertEqual(model.numberOfSections(in: UITableView()), 2)
    }

    func testNumberOfRowsInTableSection1Is1() {
        let model = DiscogsArtistModel(artist: artist)
        XCTAssertEqual(model.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }

    func testCollectionViewNumberOfSectionsIs2() {
        let model = DiscogsArtistModel(artist: artist)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        XCTAssertEqual(model.numberOfSections(in: collectionView), 2)
    }

    func testNumberOfItemsInTableSection1Is1() {
        let model = DiscogsArtistModel(artist: artist)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        XCTAssertEqual(model.collectionView(collectionView, numberOfItemsInSection: 0), 1)
    }

}
