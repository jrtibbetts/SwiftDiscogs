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

    var scrubberView: PlayerScrubberView! {
        return playerView!.scrubberView!
    }

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: PlayerView.self))
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "Player") as! PlayerViewController
        _ = playerViewController.view
        playerView = (playerViewController.view as? PlayerView)!
    }

    // MARK: - PlayerButton tests
    
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

    func testModelWithPreviousAndNextTracksAndPlaying() {
        let model = PlayerModel() <~ {
            $0.hasPrevious = true
            $0.hasNext = true
            $0.isPlaying = true
            $0.elapsedTime = 124.0
            $0.mediaDuration = 211.0
        }
        playerView.model = model
        assertPlayerButtonStates(previous: true, rewind: true, play: true, forward: true, next: true)
    }

    func testAllButtonsDisabledWithNilModel() {
        playerView.model = nil
        assertPlayerButtonStates(previous: false, rewind: false, play: false, forward: false, next: false)
    }

    func assertPlayerButtonStates(previous: Bool,
                                  rewind: Bool,
                                  play: Bool,
                                  forward: Bool,
                                  next: Bool,
                                  file: StaticString = #file,
                                  line: UInt = #line) {
        XCTAssertEqual(buttonView.previousTrackButton!.isEnabled, previous, "Previous track button", file: file, line: line)
        XCTAssertEqual(buttonView.rewindButton!.isEnabled, rewind, "Rewind button", file: file, line: line)
        XCTAssertEqual(buttonView.playButton!.isEnabled, play, "Play button", file: file, line: line)
        XCTAssertEqual(buttonView.forwardButton!.isEnabled, forward, "Forward button", file: file, line: line)
        XCTAssertEqual(buttonView.nextTrackButton!.isEnabled, next, "Next track button", file: file, line: line)
    }

}
