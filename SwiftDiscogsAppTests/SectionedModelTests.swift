//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import Stylobate
import XCTest

class SectionedModelTests: XCTestCase {

    func testEmptyInitializerHasNoSections() {
        let model = SectionedModel()
        
        XCTAssertEqual(model.tableView.numberOfSections, 0)
        XCTAssertEqual(model.collectionView.numberOfSections , 0)
    }
    
    func testInitializerWith1Section() {
        let section = SectionedModel.Section(cellID: "section1CellID", headerText: "Section 1 Header Text")
        let model = SectionedModel(sections: [section])
        XCTAssertEqual(model.tableView.numberOfSections, 1)
        XCTAssertEqual(model.collectionView.numberOfSections, 1)

        XCTAssertEqual(model.sections[0].cellID, "section1CellID")
        XCTAssertEqual(model.headerTitle(forSection: 0), "Section 1 Header Text")
    }
    
}

private extension SectionedModel {
    
    var collectionView: UICollectionView {
        return UICollectionView(frame: CGRect(),
                                collectionViewLayout: UICollectionViewFlowLayout()) <~ { $0.dataSource = self }
    }
    
    var tableView: UITableView {
        return UITableView(frame: CGRect()) <~ { $0.dataSource = self}
    }

}
