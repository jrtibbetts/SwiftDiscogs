//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

open class Controller: UIViewController {

    @IBOutlet open var model: Model!

    @IBOutlet open var display: Display!

    // MARK: UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()

        if model == nil {
            assertionFailure("The model can't be nil when viewDidLoad() is called.")
        }

        if display == nil {
            assertionFailure("The display can't be nil when viewDidLoad() is called.")
        }

        display.model = model
    }

}
