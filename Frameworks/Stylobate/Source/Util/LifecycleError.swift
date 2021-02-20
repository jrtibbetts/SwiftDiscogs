//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public enum LifecycleError: String, Error {

    case weakSelfOutOfScope = "A weak self went out of scope before the block could be invoked."

}
