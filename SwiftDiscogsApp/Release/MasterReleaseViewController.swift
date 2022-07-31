//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs
import UIKit

public class MasterReleaseViewController: BaseReleaseViewController {

    // MARK: - Public Properties

    public override var masterRelease: MasterRelease? {
        didSet {
            navigationItem.title = masterRelease?.title
        }
    }

    public var releaseSummary: ReleaseSummary? {
        didSet {
            if let masterReleaseID = releaseSummary?.id {
                // Get the master release itself.
                Task {
                    masterRelease = try await DiscogsManager.discogs.masterRelease(identifier: masterReleaseID)

                    // Get the master release's versions. We don't have to wait for
                    // the actual master release itself to be retrieved.
                    masterReleaseModel?.releaseVersions = try await DiscogsManager.discogs.releasesForMasterRelease(masterReleaseID,
                                                                                                                    pageNumber: 1,
                                                                                                                    resultsPerPage: 200).versions
                    display?.refresh()
                }
            }
        }
    }

    // MARK: - Private Properties

    private var masterReleaseModel: MasterReleaseModel? {
        get {
            return model as? MasterReleaseModel
        }

        set {
            model = newValue
        }
    }

    // MARK: - UIViewController

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReleaseVersion",
            let versionViewController = segue.destination as? ReleaseVersionViewController {
            versionViewController.masterRelease = masterRelease

            if let selectedIndex = display?.tableView?.indexPathForSelectedRow {
                versionViewController.releaseVersion = masterReleaseModel?.releaseVersions?[selectedIndex.row]
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        masterReleaseModel = MasterReleaseModel()

        // Clear out storyboard strings
        navigationItem.title = ""
    }

    private class MasterReleaseModel: ReleaseModel {

        // MARK: - Public Properties

        public var releaseVersions: [MasterReleaseVersion]?

        // MARK: - Private Properties

        private let versionsSection = Section(cellID: "versionCell", headerText: L10n.versions)

        // MARK: - Initialization

        public override init() {
            super.init()
            sections = [tracklistSection, versionsSection]
        }

        // MARK: - UITableViewDataSource

        open override func tableView(_ tableView: UITableView,
                                     cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let section = sections[indexPath.section]

            if section === versionsSection {
                let cell = tableView.dequeueReusableCell(withIdentifier: section.cellID,
                                                         for: indexPath)
                if let cell = cell as? ReleaseVersionTableCell,
                    let releaseSummary = releaseVersions?[indexPath.row] {
                    cell.setUp(with: releaseSummary)
                }

                return cell
            } else {
                return super.tableView(tableView, cellForRowAt: indexPath)
            }
        }

        public override func tableView(_ tableView: UITableView,
                                       numberOfRowsInSection sectionIndex: Int) -> Int {
            let section = sections[sectionIndex]

            if section === versionsSection {
                return releaseVersions?.count ?? 0
            } else {
                return super.tableView(tableView, numberOfRowsInSection: sectionIndex)
            }
        }

    }

}
