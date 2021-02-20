//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

public typealias TextResizingPinchEnded = (TextResizingPinchGestureRecognizer) -> Void

/// A pinch gesture recognizer that resizes text in a `UITextView`. This is
/// an innovation of my own design; at least, I've never seen any other app do
/// this, but I wish they did. **Note: do NOT assign another delegate to this
/// recognizer, because it implements the protocol itself and uses it to
/// determine whether gestures should begin.**
open class TextResizingPinchGestureRecognizer: UIPinchGestureRecognizer {

    // MARK: - Properties

    /// The size of the font when the gesture begins. The default value `0.0`,
    /// but it will be reset every time the gesture begins.
    public var initialFontSize: CGFloat = 0.0

    public private(set) var inProgress = false

    /// A delegate-type block that gets fired *as soon as the pinch gesture
    /// ends*, not when the animation ends.
    public var pinchEnded: TextResizingPinchEnded

    /// A delegate function that's called every time the size changes in
    /// in response to a drag.
    public var sizeChanged: ((CGFloat) -> Void)?

    /// A delegate function that's called when the size changes back to its
    /// original value. This may be used to disable a save button, for example.
    public var sizeRevertedToOriginalValue: ((CGFloat) -> Void)?

    /// The text view. It's held weakly because the text view holds onto the
    /// gesture strongly.
    ///
    /// - see: UIView.addGestureRecognizer(:)
    public private(set) weak var textView: UITextView!

    // MARK: - Private Properties

    /// A rounded background container for the `fontSizeButton`.
    private var fontSizeBox = UIView()

    /// A button that displays the font size as it changes. It is positioned in
    /// the upper-right corner of the text view.
    private var fontSizeButton = UIButton()

    // MARK: - Initialization

    public init(textView: UITextView,
                pinchEnded: @escaping TextResizingPinchEnded) {
        self.textView = textView
        self.pinchEnded = pinchEnded

        // self can't be set as the target in the call to super.init() because
        // it's not initialized yet.
        super.init(target: nil, action: nil)

        textView.addGestureRecognizer(self)
        delegate = self

        // now it can be set
        addTarget(self, action: #selector(resizeFont))

        setUp()
    }

    private func setUp() {
        textView.addSubview(fontSizeBox)
        fontSizeBox.layer.cornerRadius = 4.0
        fontSizeBox.layer.masksToBounds = true
        fontSizeBox.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        fontSizeBox.translatesAutoresizingMaskIntoConstraints = false
        textView.layoutMarginsGuide.topAnchor.constraint(equalTo: fontSizeBox.topAnchor,
                                                         constant: 8.0).isActive = true
        textView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: fontSizeBox.trailingAnchor).isActive = true

        fontSizeButton.addTarget(self,
                                 action: #selector(selectFont(button:)),
                                 for: .touchUpInside)
        if #available(iOS 11.0, *) {
            fontSizeButton.contentHorizontalAlignment = .trailing
        } else {
            // It will be centered, just like any other button.
        }
        fontSizeButton.tintColor = .white
        fontSizeButton.translatesAutoresizingMaskIntoConstraints = false

        fontSizeBox.addSubview(fontSizeButton)
        fontSizeBox.layoutMarginsGuide.topAnchor.constraint(equalTo: fontSizeButton.topAnchor).isActive = true
        fontSizeBox.layoutMarginsGuide.bottomAnchor.constraint(equalTo: fontSizeButton.bottomAnchor).isActive = true
        fontSizeBox.layoutMarginsGuide.leadingAnchor.constraint(equalTo: fontSizeButton.leadingAnchor).isActive = true
        fontSizeBox.layoutMarginsGuide.trailingAnchor.constraint(equalTo: fontSizeButton.trailingAnchor).isActive = true

        fontSizeBox.isHidden = true

        textView.addGestureRecognizer(self)
    }

    // MARK: - Actions

    @objc func selectFont(button: UIButton) {
        print("selectFont() tapped")
    }

    @objc func resizeFont() {
        guard let textView = textView, let font = textView.font else {
            return
        }

        switch state {
        case .began:
            beginResizingFont(font)
        case .changed:
            changeFontSize(font)
        case .ended:
            stopResizingFont(font)
        default:
            // Ignore it.
            return
        }
    }

    private func beginResizingFont(_ font: UIFont) {
        inProgress = true  // prevent another pinch before this one's done.
        initialFontSize = font.pointSize
        fontSizeBox.isHidden = false
        textView.bringSubviewToFront(fontSizeBox)

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.fontSizeBox.alpha = 1.0
        }
    }

    private func changeFontSize(_ font: UIFont) {
        guard scale != 1.0 else {
            sizeRevertedToOriginalValue?(initialFontSize)
            return
        }

        let newSize = (initialFontSize * scale).rounded(.toNearestOrAwayFromZero)

        // Keep it within certain bounds
        if 7.0 <= newSize && newSize <= 100.0 {
            let newFont = font.withSize(newSize)
            textView.font = newFont
            fontSizeButton.setTitle(L10n.fontSizeButtonTitle("\(Int(newFont.pointSize))"),
                                    for: .normal)
            sizeChanged?(newSize)
        }
    }

    private func stopResizingFont(_ font: UIFont) {
        pinchEnded(self)

        UIView.animate(withDuration: 1.0,
                       delay: 2.0,
                       animations: { [weak self] in
                        self?.fontSizeBox.alpha = 0.0
            },
                       completion: { [weak self] _ in
                        guard let self = self else { return }

                        self.fontSizeBox.isHidden = true
                        self.textView.sendSubviewToBack(self.fontSizeBox)
                        // re-enable pinches
                        self.inProgress = false
        })
    }

}

extension TextResizingPinchGestureRecognizer: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !inProgress
    }

}
