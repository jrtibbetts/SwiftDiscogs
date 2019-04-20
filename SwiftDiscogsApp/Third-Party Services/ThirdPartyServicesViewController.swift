//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

open class ThirdPartyService: NSObject {

    var serviceDescription: String?

    var image: UIImage?

    var name: String

    init(name: String) {
        self.name = name
        super.init()
    }

}

protocol AuthenticatedService: ThirdPartyService {

    
}

protocol ImportableService: ThirdPartyService {


}

class ThirdPartyServiceCell: UITableViewCell {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var importView: UIView!
    @IBOutlet weak var importProgressBar: UIProgressView!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var importStatusLabel: UILabel!

    weak var service: ThirdPartyService? {
        didSet {
            if let authenticatedService = service as? AuthenticatedService {
                signInView.isHidden = false
            } else {
                signInView.isHidden = true
            }

            if let importableService = service as? ImportableService {
                importView.isHidden = false
            } else {
                importView.isHidden = true
            }
        }
    }

}

class DiscogsService: ThirdPartyService, ImportableService, AuthenticatedService {

    init() {
        super.init(name: "Discogs")
    }

}

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
