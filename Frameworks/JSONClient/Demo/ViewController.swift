//  Copyright © 2018 Poikile Creations. All rights reserved.

import JSONClient
import PromiseKit
import Stylobate
import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets

    @IBOutlet weak var githubUsernameField: UITextField!

    @IBOutlet weak var outputLabel: UILabel!

    @IBOutlet weak var signInButton: UIButton!

    // MARK: - Other Properties

    private var gitHubClient = GitHubClient()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        githubUsernameField.delegate = self
        outputLabel.isEnabled = false
        signInButton.isEnabled = false
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text, text.count > 0 {
            signInButton.isEnabled = string.count > 0
        } else {
            signInButton.isEnabled = false
        }

        return true
    }

    // MARK: - Actions

    @IBAction func loadGitHub(sender: UIView?) {
        let promise: Promise<GitHubUser> = gitHubClient.user(userName: githubUsernameField.text!)
        promise.done { (user) -> Void in
            self.outputLabel.text = user.name
            self.outputLabel.isEnabled = true
            }.catch { (error) in
                self.outputLabel.text = "Error: \(error.localizedDescription)"
        }
    }

}
