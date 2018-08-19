//  Copyright © 2018 Poikile Creations. All rights reserved.

import SwiftDiscogs
import UIKit

open class DiscogsSignInViewController: UIViewController {

    // MARK: - Private Properties

    fileprivate var discogs: Discogs?

    // MARK: - Actions

    /// Sign into the Discogs service, notifying the display when it's about to
    /// do so and after the user has logged in successfully.
    @IBAction func signInToDiscogs(sender: UIButton?) {
        let senderInitialTitle = sender?.title(for: .normal)
        sender?.isEnabled = false
        sender?.setTitle("Signing In", for: .normal)

        defer {
            sender?.isEnabled = true
            sender?.setTitle(senderInitialTitle, for: .normal)
        }
        
        discogs = DiscogsClient.singleton
        let promise = discogs?.authorize(presentingViewController: self,
                                         callbackUrlString: AppDelegate.callbackUrl.absoluteString)
        promise?.then { [weak self] (credential) -> Void in
            self?.performSegue(withIdentifier: "signInSuccessful", sender: self)
            }.catch { (error) in    // not weak self because of Bundle(for:)
                let alertTitle = NSLocalizedString("discogsSignInFailed",
                                                   tableName: nil,
                                                   bundle: Bundle(for: type(of: self)),
                                                   value: "Discogs sign-in failed",
                                                   comment: "Title of the alert that appears when sign-in is unsuccessful.")
                self.presentAlert(for: error, title: alertTitle)
        }
    }

    @IBAction func returnToLoginScene(unwindSegue: UIStoryboardSegue) {
        let alert = UIAlertController(title: "Unimplemented", message: "You can't yet sign out of Discogs.com.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - UIViewController

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.description == "signInSuccessful",
            let searchVC = segue.destination as? DiscogsSearchViewController {
            searchVC.discogs = discogs
        }
    }

}
