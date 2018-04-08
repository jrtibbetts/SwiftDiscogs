//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogs
@testable import SwiftDiscogsApp
import PromiseKit
import XCTest

class DiscogsArtistModelTests: XCTestCase {

    var discogsClient = MockDiscogs()

    lazy var artist: DiscogsArtist = {
        let url = URL(string: "http://www.cnn.com")!
        let bio = "This is where the artist's biography will appear."
        return DiscogsArtist(dataQuality: nil, id: 99, images: nil, members: nil, name: "foo", namevariations: nil, profile: bio, releasesUrl: url, resourceUrl: "", urls: nil)
    }()

    lazy var model: DiscogsArtistModel = {
        return DiscogsArtistModel(artist: artist)
    }()

    // MARK: init(artist:)

    func testInitializerWithArtist() {
        _ = discogsClient.artist(identifier: 99).then { (artist) -> Void in
            XCTAssertEqual(self.model.artist.id, 99)
            }.catch { (error) in
                XCTFail(error.localizedDescription)
        }
    }

    // MARK: UITableViewDataSource

    func testTableViewNumberOfSectionsIs2() {
        XCTAssertEqual(model.numberOfSections(in: UITableView()), 2)
    }

    func testNumberOfRowsInTableSection1Is1() {
        XCTAssertEqual(model.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }

    func testTitlesForTableSectionsAreBioAndRelease() {
        let tableView = UITableView()
        XCTAssertEqual(model.tableView(tableView, titleForHeaderInSection: 0), "Bio")
        XCTAssertEqual(model.tableView(tableView, titleForHeaderInSection: 1), "Releases")
    }

    func testCellForTableAtIndexReturnsExpectedCell() {
        let cell = model.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0))

        guard let bioCell = cell as? DiscogsArtistBioTableCell else {
            XCTFail("The cell at (0, 0) should be a DiscogsArtistBioTableCell.")
            return
        }

        XCTAssertNil(bioCell.bioText)
        XCTAssertNil(bioCell.bioLabel)

        bioCell.bioText = "This is a sample biography."

        XCTAssertEqual(bioCell.bioLabel?.text, bioCell.bioText)
    }

    // MARK: UICollectionViewDataSource

    func testCollectionViewNumberOfSectionsIs2() {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        XCTAssertEqual(model.numberOfSections(in: collectionView), 2)
    }

    func testNumberOfItemsInTableSection1Is1() {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        XCTAssertEqual(model.collectionView(collectionView, numberOfItemsInSection: 0), 1)
    }

}
