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

    public var releaseVersion: MasterReleaseVersion?

    // MARK: - Initialization

    override init() {
        super.init()
        sections = [tracklistSection]
    }

}

public class ReleaseVersionView: CoverArtAndTableView {

    // MARK: - Public Properties

    public var releaseVersion: MasterReleaseVersion? {
        didSet {
            refresh()
        }
    }

    public override func refresh() {
        super.refresh()
        navigationItem?.title = releaseVersion?.title
    }

}
