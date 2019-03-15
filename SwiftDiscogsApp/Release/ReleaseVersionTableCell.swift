//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

public class ReleaseVersionTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var titleLabel: UILabel?

    public func setUp(with release: MasterReleaseVersion) {
        titleLabel?.text = release.title

        var text = release.majorFormats?.joined(separator: " ").appending(" ") ?? ""

        if let country = release.country {
            text.append("\(country) ")
        }

        if let label = release.label {
            text.append("\(label) ")
        }

        if let catalogNumber = release.catno?.split(separator: ",").first {
            text.append(String(catalogNumber))
        }

        titleLabel?.text = text
    }

}
