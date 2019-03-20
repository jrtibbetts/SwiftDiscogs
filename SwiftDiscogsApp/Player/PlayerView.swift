//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

public class PlayerView: Display {

    // MARK: - Outlets

    @IBOutlet internal weak var buttonView: PlayerButtonView?

    @IBOutlet internal weak var scrubberView: PlayerScrubberView?

    @IBOutlet internal weak var sourceLogoView: UIImageView?

    @IBOutlet internal weak var sourceNameView: UILabel?

    // MARK: - Public Properties

    public var model: PlayerModel? {
        didSet {
            buttonView?.model = model
            scrubberView?.model = model
            refresh()
        }
    }

    // MARK: - Display

    public override func refresh() {
        super.refresh()

        buttonView?.isHidden = (model == nil)
        scrubberView?.isHidden = (model == nil)

        buttonView?.refresh()
        scrubberView?.refresh()
    }

}

public class PlayerScrubberView: UIView {

    // MARK: - Outlets

    @IBOutlet internal weak var elapsedTimeLabel: UILabel?

    @IBOutlet internal weak var remainingTimeLabel: UILabel?

    @IBOutlet internal weak var scrubber: UISlider?

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

        elapsedTimeLabel?.text = timeFormatter.string(from: model.elapsedTime)

        if displayRemainingTime {
            remainingTimeLabel?.text = timeFormatter.string(from: model.mediaDuration - model.elapsedTime)
        } else {
            remainingTimeLabel?.text = timeFormatter.string(from: model.mediaDuration)
        }

        scrubber?.minimumValue = 0.0
        scrubber?.maximumValue = Float(model.mediaDuration)
        scrubber?.setValue(Float(model.elapsedTime), animated: true)
    }
}

public class PlayerButtonView: UIView {

    // MARK: - Outlets

    @IBOutlet internal weak var forwardButton: UIButton?

    @IBOutlet internal weak var nextTrackButton: UIButton?

    @IBOutlet internal weak var playButton: UIButton?

    @IBOutlet internal weak var previousTrackButton: UIButton?

    @IBOutlet internal weak var rewindButton: UIButton?

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
