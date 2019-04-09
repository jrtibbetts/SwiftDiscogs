//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

class DiscogsDisambiguationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!

    var searchResults: [SearchResult]? {
        didSet {
            tableView?.reloadData()
        }
    }

    weak var artistViewController: DiscogsArtistViewController?

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistSearchResultCell", for: indexPath)

        if let summary = searchResults?[indexPath.row] {
            cell.textLabel?.text = summary.title
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        artistViewController?.artistSearchResult = searchResults?[indexPath.row]
        close()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Other Functions

    @IBAction func close() {
        dismiss(animated: true)
    }

}
