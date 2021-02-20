//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// Implemented by views that want to show & hide something other than a
/// spinner or progress view.
public protocol VisualIndicatorBusyView: BusyView {

    var busyIndicator: UIView? { get set }

}

public extension VisualIndicatorBusyView where Self: UIView {

    func startActivity(completion: BusyView.ActivityCompletion? = nil) {
        summon(busyIndicator)
        completion?()
    }

    func stopActivity(completion: BusyView.ActivityCompletion? = nil) {
        banish(busyIndicator)
        completion?()
    }

}
