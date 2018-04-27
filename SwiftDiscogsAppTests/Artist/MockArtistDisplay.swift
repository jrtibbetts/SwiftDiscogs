//
//  MockArtistDisplay.swift
//  SwiftDiscogsAppTests
//
//  Created by Jason R Tibbetts on 4/26/18.
//  Copyright © 2018 Poikile Creations. All rights reserved.
//

@testable import SwiftDiscogsApp
import UIKit

class MockArtistDisplay: Display {

    var refreshWasCalled = false

    override func refresh() {
        super.refresh()
        refreshWasCalled = true
    }

}
