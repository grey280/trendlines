import SwiftUI

// Lightly modified from https://stackoverflow.com/a/56763282
public struct PartialRoundedRectangle: Shape {
    public init(topLeft: CGFloat = 0.0, topRight: CGFloat = 0.0, bottomLeft: CGFloat = 0.0, bottomRight: CGFloat = 0.0) {
        tl = topLeft
        tr = topRight
        bl = bottomLeft
        br = bottomRight
    }
    
    let tl: CGFloat
    let tr: CGFloat
    let bl: CGFloat
    let br: CGFloat

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.closeSubpath()
        return path
    }
}

public extension PartialRoundedRectangle {
    init(top: CGFloat) {
        self.init(topLeft: top, topRight: top)
    }
    init(left: CGFloat) {
        self.init(topLeft: left, bottomLeft: left)
    }
    init(right: CGFloat) {
        self.init(topRight: right, bottomRight: right)
    }
    init(bottom: CGFloat) {
        self.init(bottomLeft: bottom, bottomRight: bottom)
    }
}

struct PartialRoundedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PartialRoundedRectangle().stroke(Color.black).frame(width: 100, height: 100, alignment: .center)
            PartialRoundedRectangle(topLeft: 10).stroke(Color.black).frame(width: 100, height: 100, alignment: .center)
            PartialRoundedRectangle(topRight: 10).stroke(Color.black).frame(width: 100, height: 100, alignment: .center)
            PartialRoundedRectangle(bottomLeft: 10).stroke(Color.black).frame(width: 100, height: 100, alignment: .center)
            PartialRoundedRectangle(bottomRight: 10).stroke(Color.black).frame(width: 100, height: 100, alignment: .center)
        }
    }
}
