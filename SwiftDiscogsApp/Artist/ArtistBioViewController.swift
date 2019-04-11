//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

class ArtistBioViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var bioField: UITextView!

    // MARK: - Properties

    var artist: Artist?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        bioField.text = artist?.profile
        navigationItem.title = artist?.name
    }

}
