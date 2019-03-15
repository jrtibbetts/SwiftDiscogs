//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

class ReleaseVersionViewController: UIViewController, DiscogsProvider {

    // MARK: - Public Properties

    public var discogs: Discogs? = DiscogsClient.singleton

    public var masterRelease: MasterRelease? {
        get {
            return model.masterRelease
        }

        set {
            model.masterRelease = newValue
            tableView?.reloadData()
        }
    }

    public var releaseVersion: MasterReleaseVersion? {
        get {
            return model.releaseVersion
        }

        set {
            model.releaseVersion = newValue
            tableView?.reloadData()
        }
    }

    // MARK: - Private Properties

    private var model = Model()

    @IBOutlet private weak var tableView: UITableView?

    // MARK: - UIViewController

    override func viewDidLoad() {
        tableView?.dataSource = model
        tableView?.delegate = model
    }

    // MARK: - Model

    class Model: ReleaseModel {

        // MARK: - Public Properties

        public var masterRelease: MasterRelease? {
            didSet {
                tracks = masterRelease?.tracklist
            }
        }

        public var releaseVersion: MasterReleaseVersion? {
            didSet {
            }
        }

        // MARK: - Initialization

        override init() {
            super.init()
            sections = [tracklistSection]
        }

    }

}
