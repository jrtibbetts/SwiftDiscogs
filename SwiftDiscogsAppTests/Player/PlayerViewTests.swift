//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import SwiftDiscogsApp
import Stylobate
import XCTest

class PlayerViewTests: XCTestCase {

    var playerView: PlayerView!

    var buttonView: PlayerButtonView! {
        return playerView!.buttonView!
    }

    var buttons: [UIButton] {
        return [buttonView.previousTrackButton!,
                buttonView.rewindButton!,
                buttonView.playButton!,
                buttonView.forwardButton!,
                buttonView.nextTrackButton!]
    }

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: PlayerView.self))
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "Player") as! PlayerViewController
        playerView = (playerViewController.view as? PlayerView)!
    }

    func testInitialStateWithDefaultModel() {
        let model = PlayerModel()
        playerView.model = model
        buttons.forEach { XCTAssertFalse($0.isEnabled) }
    }

    func testModelWithPreviousTrackButNoNextTrackAndNotPlaying() {
        let model = PlayerModel() <~ {
            $0.hasPrevious = true
        }
        playerView.model = model
        assertPlayerButtonStates(previous: true, rewind: false, play: false, forward: false, next: false)
    }

    func testModelWithNextTrackButNoPreviousTrackAndNotPlaying() {
        let model = PlayerModel() <~ {
            $0.hasNext = true
        }
        playerView.model = model
        assertPlayerButtonStates(previous: false, rewind: false, play: false, forward: false, next: true)
    }

    func assertPlayerButtonStates(previous: Bool,
                                  rewind: Bool,
                                  play: Bool,
                                  forward: Bool,
                                  next: Bool) {
        XCTAssertEqual(buttonView.previousTrackButton!.isEnabled, previous)
        XCTAssertEqual(buttonView.rewindButton!.isEnabled, rewind)
        XCTAssertEqual(buttonView.playButton!.isEnabled, play)
        XCTAssertEqual(buttonView.forwardButton!.isEnabled, forward)
        XCTAssertEqual(buttonView.nextTrackButton!.isEnabled, next)
    }
}
