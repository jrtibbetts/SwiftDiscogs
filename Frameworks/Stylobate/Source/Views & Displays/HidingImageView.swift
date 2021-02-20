//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

/// A `UIImageView` that sets its `isHidden` property to `true` if its `image`
/// is `nil`.
open class HidingImageView: UIImageView {

    open override var image: UIImage? {
        didSet {
            isHidden = (image == nil)
        }
    }

}
