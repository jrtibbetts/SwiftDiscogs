//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import Stylobate
import UIKit

class MockArtistDisplay: Display {

    var refreshWasCalled = false

    override func refresh() {
        super.refresh()
        refreshWasCalled = true
    }

}
