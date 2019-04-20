//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

final class ThirdPartyServicesViewController: UITableViewController {

    var services: [ThirdPartyService] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        services.append(DiscogsService())
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
