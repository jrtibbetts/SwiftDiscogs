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

    // MARK: - Private Properties

    @IBOutlet private weak var display: PlaybackView?

    private var model: PlaybackModel?

}

public protocol PlaybackModel {

    var elapsedTime: TimeInterval { get set }

    var hasNext: Bool { get set }

    var hasPrevious: Bool { get set }

    var mediaDuration: TimeInterval { get set }

    var sourceLogo: UIImage? { get set }

    var sourceName: String? { get set }

}

public class PlaybackView: Display {

    // MARK: - Outlets

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
