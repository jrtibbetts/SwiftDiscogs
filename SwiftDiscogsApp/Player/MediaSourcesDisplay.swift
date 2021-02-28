//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

public class MediaSourcesDisplay: CollectionAndTableDisplay {

}

public class MediaSourceTableCell: UITableViewCell {

    @IBOutlet public weak var mediaSourceView: MediaSourceView?

}

public class MediaSourceCollectionCell: UICollectionViewCell {

    @IBOutlet public weak var mediaSourceView: MediaSourceView?

}

public class MediaSourceView: UIView {

    // MARK: - Public Properties

    public var source: MediaSource? {
        didSet {
            nameLabel?.text = source?.name

//            iconView?.isHidden = source?.iconURL == nil
            nameLabel?.isHidden = source?.iconURL != nil

            authenticationStatusStack?.isHidden = source?.authenticationStatus == nil
        }
    }

    // MARK: - Outlets

    @IBOutlet public weak var authenticationStatusStack: ToggleStackView?

    @IBOutlet public weak var iconView: UIImageView?

    @IBOutlet public weak var nameLabel: UILabel?

    @IBOutlet public weak var signedInAsLabel: UILabel?

    @IBOutlet public weak var signInButton: UIButton?

    @IBOutlet public weak var signOutButton: UIButton?

    @IBOutlet public weak var signOutStack: UIStackView?

    @IBOutlet public weak var spinner: UIActivityIndicatorView?

}
