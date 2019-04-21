//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

final class ThirdPartyServicesViewController: UITableViewController{

    // MARK: - Properties

    lazy var discogsService: DiscogsService = DiscogsService()

    var services: [ThirdPartyService] = []

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        discogsService.authenticationDelegate = self
        services.append(discogsService)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return services.isEmpty ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let service = services[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "thirdPartyServiceCell", for: indexPath)

        if let cell = cell as? ThirdPartyServiceCell {
            cell.service = service
        }

        return cell
    }

}

// MARK: - AuthenticatedServiceDelegate

extension ThirdPartyServicesViewController: AuthenticatedServiceDelegate {

    func didSignIn(toService service: AuthenticatedService?) {
        if service === discogsService {
            reloadDiscogsRow()
        }
    }

    func signIn(toService service: AuthenticatedService?,
                failedWithError error: Error?) {
        if service === discogsService {
            reloadDiscogsRow()
        }
    }

    func willSignIn(toService service: AuthenticatedService?) {
        if service === discogsService {
            reloadDiscogsRow()
        }
    }

    private func reloadDiscogsRow() {
        if let row = services.firstIndex(of: discogsService) {
            let discogsPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [discogsPath], with: .fade)
        }
    }

}
