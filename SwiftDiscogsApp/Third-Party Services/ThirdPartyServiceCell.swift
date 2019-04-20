//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

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

            logoView.image = service?.image
        }
    }

}
