//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

/// The root view of the `DiscogsSearchViewController`.
open class DiscogsSearchView: CollectionAndTableDisplay, DiscogsSearchDisplay, UISearchBarDelegate {

    // MARK: - Private Outlets

    @IBOutlet fileprivate weak var blurOverlay: UIView?

    /// The button that will launch the Discogs service's authorization web
    /// page, if necessary.
    @IBOutlet fileprivate weak var signInButton: UIButton?

    /// The button for signing out of the Discogs service.
    @IBOutlet fileprivate weak var signOutButton: UIButton?

    /// The busy indicator.
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView?

    // MARK: - Other Properties

    /// Indicates whether the user is currently signed in to Discogs.
    fileprivate var signedIn: Bool = false

    fileprivate lazy var allOfDiscogsSearchScopeTitle = NSLocalizedString("allOfDiscogsSearchScopeTitle",
                                                                          tableName: nil,
                                                                          bundle: Bundle(for: type(of: self)),
                                                                          value: "All of Discogs",
                                                                          comment: "Search scope label for searching all of Discogs")

    fileprivate lazy var userCollectionSearchScopeTitle = NSLocalizedString("userCollectionSearchScopeTitle",
                                                                            tableName: nil,
                                                                            bundle: Bundle(for: type(of: self)),
                                                                            value: "My Collection",
                                                                            comment: "Search scope label for searching only within the user's collection")


    // MARK: - UISearchBarDelegate

    open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Prevent search-bar editing if the user's not signed in.
        return signedIn
    }

    // MARK: - DiscogsSearchDisplay

    /// Configure the view.
    open func setUp(navigationItem: UINavigationItem) {
        signedOut()

        self.navigationItem = navigationItem
        self.navigationItem?.hidesSearchBarWhenScrolling = false

        if let searchController = navigationItem.searchController {
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.dimsBackgroundDuringPresentation = false
            searchController.obscuresBackgroundDuringPresentation = false

            setUp(searchBar: searchController.searchBar)
        }
    }

    open func tearDown() {
        // Nothing.
    }

    open func signedInAs(userName: String) {
        stopSpinning()  // spin() was called in willSignIn()
        signOutButton?.isEnabled = true
        signOutButton?.setTitle("Signed in as \(userName)", for: .normal)
        signedIn = true
        tableView?.isHidden = false

        UIView.animateKeyframes(withDuration: 0.75,
                                delay: 0.0,
                                options: .beginFromCurrentState,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.66) { [weak self] in
                                        self?.signOutButton?.transform = CGAffineTransform(scaleX: 1.33, y: 1.33)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.67, relativeDuration: 0.33) { [weak self] in
                                        self?.signOutButton?.setTitle("Sign Out", for: .normal)
                                        self?.signOutButton?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    }
        }) { [weak self] (completed) in
            self?.blurOverlay?.isHidden = true
        }
    }

    open func signedOut() {
        stopSpinning()  // spin() was called in willSignOut()
        // Even though the signed-in label will be hidden now, clear the
        // username from it to avoid any potential security risk.
        signInButton?.isHidden = false
        signOutButton?.isEnabled = false
        signedIn = false
        tableView?.isHidden = true
        blurOverlay?.isHidden = false
    }

    open func willSignIn() {
        spin()  // stopSpinning() is called in signedIn()
        signInButton?.isHidden = true
    }

    open func willSignOut() {
        spin()  // stopSpinning() is called in signedOut()
    }

    // MARK: - Other functions

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

    fileprivate func setUp(searchBar: UISearchBar) {
        searchBar.delegate = self
        searchBar.scopeButtonTitles = [allOfDiscogsSearchScopeTitle, userCollectionSearchScopeTitle]
        searchBar.selectedScopeButtonIndex = DiscogsSearchViewController.SearchScope.allOfDiscogs.rawValue
        searchBar.showsScopeBar = true
    }

}
