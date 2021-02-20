//  Created by Jason R Tibbetts on 2/14/21.

import Foundation

public class Stylobate {

    public static var resourceBundle: Bundle = {
        return Bundle(for: Stylobate.self)
// For whenever Swift Package Manager unfucks resources in bundles
//        let bundleName = "Stylobate_Stylobate.bundle"
//
//        let locationCandidates = [Bundle.main.resourceURL,
//                                  Bundle(for: Stylobate.self).resourceURL,
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

}
