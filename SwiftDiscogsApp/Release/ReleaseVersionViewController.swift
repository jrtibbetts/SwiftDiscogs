//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

class ReleaseVersionViewController: BaseReleaseViewController {

    // MARK: - Public Properties

    public var releaseVersion: MasterReleaseVersion? {
        didSet {
            setUp()
            releaseVersionModel?.releaseVersion = releaseVersion
            releaseVersionDisplay?.releaseVersion = releaseVersion

            if let releaseID = releaseVersion?.id {
                _ = DiscogsManager.discogs.release(identifier: releaseID).done { [weak self] (release) in
                    self?.release = release
                    }.catch { _ in
                }
            }
        }
    }

    public var release: Release? {
        didSet {
            releaseVersionModel?.release = release
            releaseVersionDisplay?.refresh()
        }
    }

    private var releaseVersionModel: ReleaseVersionModel? {
        return model as? ReleaseVersionModel
    }

    override var display: CoverArtAndTableView? {
        didSet {
            setUp()
            releaseVersionDisplay?.releaseVersion = releaseVersion
        }
    }

    private var releaseVersionDisplay: ReleaseVersionView? {
        return display as? ReleaseVersionView
    }

    // MARK: - Private Functions

    private func setUp() {
        if model == nil {
            model = ReleaseVersionModel()
        }

        releaseVersionDisplay?.model = releaseVersionModel
    }

}

// MARK: - Model

private class ReleaseVersionModel: ReleaseModel {

    // MARK: - Public Properties

    public var release: Release? {
        didSet {
            tracks = release?.tracklist
        }
    }

    public var releaseVersion: MasterReleaseVersion?

    // MARK: - Private Properties

    private var formatSection = Section(cellID: "formatCell")

    // MARK: - Initialization

    override init() {
        super.init()
        sections = [formatSection, tracklistSection]
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection sectionIndex: Int) -> Int {
        if sections[sectionIndex] === formatSection {
            return release?.formats?.count ?? 0
        } else {
            return super.tableView(tableView, numberOfRowsInSection: sectionIndex)
        }
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        if section === formatSection,
            let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID,
                                                     for: indexPath) as? ReleaseFormatTableCell {
            cell.format = release?.formats?[indexPath.row]

            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

}

public class ReleaseFormatTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet public weak var formatLabel: UILabel?

    // MARK: - Public Properties

    public var format: ReleaseFormat? {
        didSet {
            var string = ""

            if let countString = format?.count,  // should the type be Int?
                let count = Int(countString), count > 1 {
                string = "\(countString) "  // should probably be localized
            }

            if let formatName = format?.name {
                string += formatName
            }

            if let descriptions = format?.descriptions?.joined(separator: ", ") {
                string += " \(descriptions)"
            }

            formatLabel?.text = string
        }
    }

}

public class ReleaseVersionView: CoverArtAndTableView {

    // MARK: - Public Properties

    public var releaseVersion: MasterReleaseVersion? {
        didSet {
            refresh()
        }
    }

    public var release: Release? {
        didSet {
            release?.formats?.forEach { _ in

            }
        }
    }

    public override func refresh() {
        super.refresh()
        navigationItem?.title = releaseVersion?.title
    }

}
