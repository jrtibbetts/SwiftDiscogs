//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

public class PlayerViewController: UIViewController {

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

    @IBOutlet private weak var display: PlayerView?

    private var model: PlayerModel?

}

public class PlayerModel {

    var elapsedTime: TimeInterval = 0.0

    var hasNext: Bool = false

    var hasPrevious: Bool = false

    var isPlaying: Bool = false

    var mediaDuration: TimeInterval = 0.0

    var sourceLogo: UIImage?

    var sourceName: String?

}

public class PlayerView: Display {

    // MARK: - Outlets

    @IBOutlet private weak var buttonView: PlayerButtonView?

    @IBOutlet private weak var scrubberView: PlayerScrubberView?

    @IBOutlet private weak var sourceLogoView: UIImageView?

    @IBOutlet private weak var sourceNameView: UILabel?

    // MARK: - Public Properties

    public var model: PlayerModel? {
        didSet {
            refresh()
        }
    }

    // MARK: - Display

    public override func refresh() {
        super.refresh()
        buttonView?.refresh()
        scrubberView?.refresh()
    }

}

public class PlayerScrubberView: UIView {

    // MARK: - Outlets

    @IBOutlet private weak var elapsedTimeLabel: UILabel?

    @IBOutlet private weak var remainingTimeLabel: UILabel?

    @IBOutlet private weak var scrubber: UISlider?

    // MARK: - Public Properties

    public var model: PlayerModel? {
        didSet {
            refresh()
        }
    }

    // MARK: - Private Properties

    private var displayRemainingTime: Bool = false

    private var timeFormatter = DateComponentsFormatter() <~ {
        $0.unitsStyle = .brief
        $0.allowedUnits = [.hour, .minute, .second]
        $0.zeroFormattingBehavior = .dropLeading
    }

    // MARK: - Functions

    public func refresh() {
        guard let model = model else {
            return
        }

        // Timeline scrubber
        elapsedTimeLabel?.text = timeFormatter.string(from: model.elapsedTime)

        if displayRemainingTime {
            remainingTimeLabel?.text = timeFormatter.string(from: model.mediaDuration - model.elapsedTime)
        } else {
            remainingTimeLabel?.text = timeFormatter.string(from: model.mediaDuration)
        }

        scrubber?.minimumValue = 0.0
        scrubber?.maximumValue = Float(model.mediaDuration)
        scrubber?.setValue(Float(model.elapsedTime), animated: true)

        // Buttons
    }
}

public class PlayerButtonView: UIView {

    // MARK: - Outlets

    @IBOutlet private weak var forwardButton: UIButton?

    @IBOutlet private weak var nextTrackButton: UIButton?

    @IBOutlet private weak var playButton: UIButton?

    @IBOutlet private weak var previousTrackButton: UIButton?

    @IBOutlet private weak var rewindButton: UIButton?

    // MARK: - Public Properties

    public var model: PlayerModel? {
        didSet {
            refresh()
        }
    }

    // MARK: - Functions

    public func refresh() {
        guard let model = model else {
            [forwardButton,
             nextTrackButton,
             playButton,
             previousTrackButton,
             rewindButton].forEach { $0?.isEnabled = false }
            return
        }

        forwardButton?.isEnabled = model.elapsedTime < model.mediaDuration
        nextTrackButton?.isEnabled = model.hasNext
        previousTrackButton?.isEnabled = model.hasPrevious
        rewindButton?.isEnabled = model.elapsedTime > 0.0
    }

}
