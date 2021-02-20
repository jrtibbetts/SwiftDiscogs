//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public extension TimeInterval {

    // swiftlint:disable colon
    var seconds: TimeInterval { return TimeInterval(self) }
    var minutes: TimeInterval { return  60.0 * seconds }
    var hours:   TimeInterval { return  60.0 * minutes }
    var days:    TimeInterval { return  24.0 * hours   }
    var weeks:   TimeInterval { return   7.0 * days    }
    var years:   TimeInterval { return 365.0 * days    }

}
