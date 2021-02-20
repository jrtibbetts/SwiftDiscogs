//  Created by Jason R Tibbetts on 2/14/21.

@testable import Stylobate
import Foundation
import XCTest

public class StylobateTests: XCTestCase {

    public static var resourceBundle: Bundle = {
        return Bundle(for: StylobateTests.self)
// For whenever Swift Package Manager unfucks resources in bundles
//        let bundleName = "Stylobate_StylobateTests.bundle"
//
//        let locationCandidates = [Bundle.main.resourceURL,
//                                  Bundle(for: StylobateTests.self).resourceURL,
//                                  Bundle.main.bundleURL]
//
//        for path in locationCandidates {
//            if let bundleUrl = path?.appendingPathComponent(bundleName),
//               let bundle = Bundle(url: bundleUrl) {
//                return bundle
//            }
//        }
//
//        fatalError("Failed to load the resource bundle from \(locationCandidates)")
    }()

    func testStylobateResourceBundle() {
        let stylobateResources = Stylobate.resourceBundle
        XCTAssertNotNil(stylobateResources.url(forResource: "Strings", withExtension: "strings"))
    }

}
