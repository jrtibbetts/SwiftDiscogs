//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

public class PlaybackViewController: UIViewController {

    // MARK: - Actions

    @IBAction private func goToNextTrack(source: UIButton?) {

    }

    @IBAction private func goToPreviousTrack(source: UIButton?) {

    }

    @IBAction private func forward(source: UIButton?) {

    }

    @IBAction private func play(source: UIButton?) {

    }

    @IBAction private func rewind(source: UIButton?) {

    }

}

public class PlaybackView: Display {

    // MARK: - Outlets

    @IBOutlet private weak var changeSourceButton: UIButton?

    @IBOutlet private weak var elapsedTimeLabel: UILabel?

    @IBOutlet private weak var forwardButton: UIButton?

    @IBOutlet private weak var nextTrackButton: UIButton?

    @IBOutlet private weak var playButton: UIButton?

    @IBOutlet private weak var previousTrackButton: UIButton?

    @IBOutlet private weak var remainingTimeLabel: UILabel?

    @IBOutlet private weak var rewindButton: UIButton?

    @IBOutlet private weak var scrubber: UISlider?

    @IBOutlet private weak var sourceLogoView: UIImageView?

    @IBOutlet private weak var sourceNameView: UILabel?

}
