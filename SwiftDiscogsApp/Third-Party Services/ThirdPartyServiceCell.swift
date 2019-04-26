//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

class ThirdPartyServiceCell: UITableViewCell {

    // MARK: - Basic Service Properties

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!

    // MARK: - Importing Service Properties

    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var importProgressBar: UIProgressView!
    @IBOutlet weak var importStatusLabel: UILabel!
    @IBOutlet weak var importView: UIView!

    // MARK: - Authenticated Service Properties

    @IBOutlet weak var signedInAsUsernameLabel: UILabel!
    @IBOutlet weak var signInOutButton: UIButton!
    @IBOutlet weak var signInView: UIView!

    weak var service: ThirdPartyService? {
        didSet {
            if let authenticatedService = service as? AuthenticatedService {
                signInView.isHidden = false

                if authenticatedService.isSignedIn {
                    signInOutButton.setTitle("Sign Out", for: .normal)
                    signedInAsUsernameLabel.text = authenticatedService.userName
                } else {
                    signInOutButton.setTitle("Sign In", for: .normal)
                    signedInAsUsernameLabel.text = nil // hides it
                }
            } else {
                signInView.isHidden = true
            }

            if let service = service as? ImportableService {
                if service.isImporting {
                    importButton.setTitle("Stop Importing", for: .normal)

                    if let importableItemCount = service.importableItemCount {
                        let progress = service.importedItemCount / importableItemCount
                        importProgressBar.setProgress(Float(progress), animated: true)
                        importStatusLabel.text = "Imported \(service.importedItemCount) of \(importableItemCount)"
                    } else {
                        importStatusLabel.text = "Imported \(service.importedItemCount)"
                    }
                } else {
                    importButton.setTitle("Import", for: .normal)
                    importProgressBar.progress = 0.0
                    importStatusLabel.text = nil
                }

                importView.isHidden = false
            } else {
                importView.isHidden = true
            }

            logoView.image = service?.image
            descriptionLabel.text = service?.serviceDescription
        }
    }

}
