//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

final class ImportStatusView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusStack: UIStackView!

    // MARK: - Functions

    func startImporting() {
        importButton.setTitle("Stop", for: .normal)
        spinner.startAnimating()
        statusLabel.text = "Importing"
        statusStack.isHidden = false
    }

    func stopImporting() {
        importButton.setTitle("Import", for: .normal)
        spinner.stopAnimating()
        statusLabel.text = ""
        statusStack.isHidden = true
    }

}
