//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import SwiftDiscogs

public class MediaSourcesViewController: CollectionAndTableViewController {

    // MARK: - Public Properties

    public var mediaSourcesDisplay: MediaSourcesDisplay? {
        return display as? MediaSourcesDisplay
    }

    public var mediaSourcesModel: MediaSourcesModel? {
        return model as? MediaSourcesModel
    }

    // MARK: - Actions

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()
        model = MediaSourcesModel()
        mediaSourcesDisplay?.model = model
    }

}

public class MediaSourcesModel: CollectionAndTableModel {

    // MARK: - Public Properties

    public var sources: [MediaSource] = [
        MediaSource(name: "Spotify"),
        MediaSource(name: "Apple Music"),
        MediaSource(name: "Amazon Music"),
        MediaSource(name: "iTunes Library")
    ]

    // MARK: - Initialization

    public override init() {
        super.init()
    }

    public init(sources: [MediaSource] = []) {
        self.sources = sources
    }

    // MARK: - UITableViewDataSource

    public override func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaSourceCell",
                                                 for: indexPath)

        if let cell = cell as? MediaSourceTableCell {
            cell.mediaSourceView?.source = sources[indexPath.row]
        }

        return cell
    }

    // MARK: - UICollectionViewDataSource

    public override func collectionView(_ collectionView: UICollectionView,
                                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaSourceCell",
                                                      for: indexPath)

        if let cell = cell as? MediaSourceCollectionCell {
            cell.mediaSourceView?.source = sources[indexPath.row]
        }

        return cell
    }

    // MARK: - CollectionAndTableModel

    public override func numberOfItems(inSection section: Int) -> Int {
        return sources.count
    }

    public override func numberOfSections() -> Int {
        return 1
    }

}
