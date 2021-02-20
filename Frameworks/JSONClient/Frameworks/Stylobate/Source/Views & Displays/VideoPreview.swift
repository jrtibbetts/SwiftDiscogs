//  Copyright © 2019 Poikile Creations. All rights reserved.

import AVFoundation
import UIKit

/// A `UIView` whose layer is an `AVCaptureVideoPreviewLayer`.
open class VideoPreview: UIView {

    // MARK: - UIView Properties

    override open class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    // MARK: - Other Properties

    /// Pass-through property for the `videoPreviewLayer.session`.
    open var avCaptureSession: AVCaptureSession? {
        get { return videoPreviewLayer.session }

        set { videoPreviewLayer.session = newValue }
    }

    /// The primary layer, force-cast as an `AVCaptureVideoPreviewLayer`.
    final public var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        // swiftlint:disable force_cast
        return layer as! AVCaptureVideoPreviewLayer
        // swiftlint:enable force_cast
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    private func setUp() {
        videoPreviewLayer.videoGravity = .resizeAspectFill
    }

}
