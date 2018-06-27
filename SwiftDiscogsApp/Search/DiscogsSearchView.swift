//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

/// The root view of the `DiscogsSearchViewController`.
open class DiscogsSearchView: CollectionAndTableDisplay, UISearchBarDelegate {

    // MARK: Private Outlets

    @IBOutlet fileprivate weak var blurOverlay: UIView?

    /// The label that displays the user's name after sign-in was successful.
    @IBOutlet fileprivate weak var signedInAsLabel: FormattedLabel?

    /// The button that will launch the Discogs service's authorization web
    /// page, if necessary.
    @IBOutlet fileprivate weak var signInButton: UIButton?

    /// The button for signing out of the Discogs service.
    @IBOutlet fileprivate weak var signOutButton: UIButton?

    /// The view that contains the `signOutButton` and `signedInAsLabel`.
    @IBOutlet fileprivate weak var signOutView: UIView?

    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView?

    // MARK: Private properties

    /// Indicates whether the user is current signed in to Discogs.
    fileprivate var signedIn: Bool = false

    // MARK: UISearchBarDelegate

    open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Prevent search-bar editing if the user's not signed in.
        return signedIn
    }

    /// Configure the view.
    func setUp(searchController: UISearchController,
               navigationItem: UINavigationItem) {
        signOutView?.isHidden = true

        stopSpinning()

        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true

        setUp(searchBar: searchController.searchBar)

        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func tearDown() {
        // Nothing.
    }

    func signedInAs(userName: String) {
        stopSpinning()
        signedIn = true
        signInButton?.isHidden = true
        signOutView?.isHidden = false
        signedInAsLabel?.text = userName
    }

    func signedOut() {
        stopSpinning()
        // Even though the signed-in label will be hidden now, clear the
        // username from it to avoid any potential security risk.
        signInButton?.isHidden = false
        signOutView?.isHidden = true
        signedIn = false
    }

    func willSignIn() {
        spin()
//        UIView.animate(withDuration: 0.3,
//                       delay: 0.0,
//                       options: .curveEaseIn,
//                       animations: { [weak self] in
//                        self?.searchBar?.alpha = CGFloat(1.0)
//            }, completion: nil)
    }

    func willSignOut() {
        spin()
//        UIView.animate(withDuration: 0.3,
//                       delay: 0.0,
//                       options: .curveEaseOut,
//                       animations: { [weak self] in
//                        self?.searchBar?.alpha = CGFloat(0.25)
//            }, completion: nil)
    }

    // MARK: Other functions

    fileprivate func spin() {
        if let blurOverlay = blurOverlay {
            bringSubview(toFront: blurOverlay)
        }

        spinner?.startAnimating()
    }

    fileprivate func stopSpinning() {
        spinner?.stopAnimating()

        if let blurOverlay = blurOverlay {
            sendSubview(toBack: blurOverlay)
        }
    }

    // Copy the dummySearchBar's settings over to the search controller's
    // bar, then remove the dummy.
    fileprivate func setUp(searchBar: UISearchBar) {
        searchBar.delegate = self
    }

}
