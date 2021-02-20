import UIKit

public extension UIBezierPath {

    /// Construct a Bézier path that draws a slice of a circle. This simply
    /// calls
    /// `UIBezierPath.init(arcCenter:radius:startAngle:endAngle:clockwise:)`
    /// and adds lines from the arc's start and end points to the center of
    /// the circle.
    ///
    /// - Parameters:
    ///   - sliceCenter: The center of the circle.
    ///   - radius: The circle's radius.
    ///   - startAngle: The angle at which the slice starts.
    ///   - endAngle: The angle at which it ends.
    ///   - clockwise: `true` if the slice should be drawn clockwise. The
    ///     default is `true`.
    convenience init(sliceCenter: CGPoint,
                     radius: CGFloat,
                     startAngle: CGFloat,
                     endAngle: CGFloat) {
        self.init(arcCenter: sliceCenter,
                  radius: radius,
                  startAngle: startAngle,
                  endAngle: endAngle,
                  clockwise: true)
        addLine(to: sliceCenter)
        close()
    }

}
