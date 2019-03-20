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

    @IBOutlet internal weak var display: PlayerView?

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
