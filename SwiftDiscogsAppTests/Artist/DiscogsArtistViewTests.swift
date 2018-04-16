//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import XCTest

class DiscogsArtistViewTests: XCTestCase {

    func testInitializationHasNilProperties() {
        let view = DiscogsArtistView()
        XCTAssertNil(view.model)
        XCTAssertNil(view.tableView)
        XCTAssertNil(view.collectionView)
    }

    func testSettingModelBeforeTableViewOk() {
        let view = DiscogsArtistView()
        let artist = DiscogsArtistModelTests().artist
        let model = DiscogsArtistModel(artist: artist)
        view.model = model
        XCTAssertNotNil(view.model)

        let tableView = UITableView()
        view.tableView = tableView
        XCTAssertNotNil(view.tableView)
        XCTAssertTrue(view.tableView?.dataSource === view.model)
        XCTAssertTrue(view.tableView?.delegate === view.model)
    }

    func testSettingTableViewBeforeModelOk() {
        let view = DiscogsArtistView()
        let artist = DiscogsArtistModelTests().artist
        let tableView = UITableView()
        view.tableView = tableView
        XCTAssertNotNil(view.tableView)

        let model = DiscogsArtistModel(artist: artist)
        view.model = model
        XCTAssertNotNil(view.model)
        XCTAssertTrue(view.tableView?.dataSource === view.model)
        XCTAssertTrue(view.tableView?.delegate === view.model)
    }

    func testSettingModelBeforeCollectionViewOk() {
        let view = DiscogsArtistView()
        let artist = DiscogsArtistModelTests().artist
        let model = DiscogsArtistModel(artist: artist)
        view.model = model
        XCTAssertNotNil(view.model)

        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        view.collectionView = collectionView
        XCTAssertNotNil(view.collectionView)
        XCTAssertTrue(view.collectionView?.dataSource === view.model)
        XCTAssertTrue(view.collectionView?.delegate === view.model)
    }

    func testSettingCollectionViewBeforeModelOk() {
        let view = DiscogsArtistView()
        let artist = DiscogsArtistModelTests().artist
        let collectionView = UICollectionView(frame: CGRect(),
                                              collectionViewLayout: UICollectionViewFlowLayout())
        view.collectionView = collectionView
        XCTAssertNotNil(view.collectionView)

        let model = DiscogsArtistModel(artist: artist)
        view.model = model
        XCTAssertNotNil(view.model)
        XCTAssertTrue(view.collectionView?.dataSource === view.model)
        XCTAssertTrue(view.collectionView?.delegate === view.model)
    }

}
