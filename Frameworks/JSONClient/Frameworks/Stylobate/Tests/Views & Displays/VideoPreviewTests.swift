//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
import AVFoundation
import XCTest

class VideoPreviewTests: XCTestCase {

    func testAVCaptureSessionAccessors() {
        let view = VideoPreview(frame: .zero)

        let session = AVCaptureSession()
        view.avCaptureSession = session
        XCTAssertTrue(view.avCaptureSession === session)
    }

    func testLayerType() {
        let view = VideoPreview(frame: .zero)
        XCTAssertTrue(view.layer is AVCaptureVideoPreviewLayer)
        XCTAssertEqual(view.videoPreviewLayer.videoGravity, .resizeAspectFill)
    }

    func testLoadFromNib() {
        let bundle = StylobateTests.resourceBundle
        let nib = UINib(nibName: "VideoPreview", bundle: bundle)
        let views = nib.instantiate(withOwner: nil, options: nil)
        if let view = views.first as? VideoPreview {
            XCTAssertTrue(view.layer is AVCaptureVideoPreviewLayer)
        } else {
            XCTFail("Expected to find a single VideoPreview object in the VideoPreview xib.")
        }
    }
}
