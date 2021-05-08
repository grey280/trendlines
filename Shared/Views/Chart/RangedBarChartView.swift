//
//  RangedBarChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct RangedBarChartView: View {
    public init(
        data: [DatePoint],
        color: Color = .gray,
        yRange: (min: Double, max: Double)? = nil
    ) {
        self.data = data.sorted(by: { (a, b) -> Bool in
            a.x < b.x
        })
        self.color = color
        if let overrideY = yRange {
            self.yRange = overrideY
        } else {
            let ySorted = data.flatMap { [$0.yMin, $0.yMax] }.compactMap { $0 }.sorted()
            self.yRange = (ySorted.first ?? 0.0, ySorted.last ?? 0.0)
        }
    }
    
    let data: [DatePoint]
    let color: Color
    
    private let yRange: (min: Double, max: Double)
    
    var spacing: CGFloat {
        switch data.count {
        case 0..<10:
            return 8
        case 10..<20:
            return 6
        default:
            return 4
        }
    }
    
    private func barWidth(_ source: CGSize) -> CGFloat {
        (source.width - (spacing * CGFloat(data.count))) / CGFloat(data.count)
    }
    
    private func barHeight(_ source: CGSize, y: Double) -> CGFloat {
        #warning("this isn't working right - barHeight needs to know about both min and max")
        let calculated = CGFloat(y / (yRange.max - yRange.min)) * source.height
        if (calculated < 0) {
            return 0
        }
        return calculated
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = barWidth(geo.size)
            let widthStep = spacing + width
            let radius = width / 4
            ForEach(0..<data.count) { index in
                if let dataPoint = data[index] {
                    let x = (CGFloat(index) * widthStep) + (width / CGFloat(2))
                    let height = barHeight(geo.size, y: (dataPoint.yMax ?? dataPoint.y) - (dataPoint.yMin ?? dataPoint.y))
                    if height > 0 {
                        let heightDelta = (yRange.max - yRange.min) - (dataPoint.yMax ?? dataPoint.y)
                        let y = barHeight(geo.size, y: heightDelta)
//                        let y = (geo.size.height - height) + (height / CGFloat(2))
                        ZStack {
                            RoundedRectangle(cornerRadius: radius)
                                .fill(self.color.opacity(0.4))
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(self.color)//, style: StrokeStyle(lineWidth: 4))
                        }
                        .frame(width: width, height: height)
                        .position(x: x, y: y)
                    }
                }
            }
        }
    }
}

struct RangedBarChartView_Previews: PreviewProvider {
    private static let _points: [DatePoint] = {
        var pointBuilder: [DatePoint] = []
        var workingDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        for i in -2..<3 {
            let low: Double = Double(i) - (Double(i)/2)
            let high: Double = Double(i) + (Double(i)/2)
            pointBuilder.append(.init(workingDate, yMin: low, yMax: high))
            workingDate = Calendar.current.date(byAdding: .day, value: 1, to: workingDate)!
        }
        return pointBuilder
    }()
    
    static var previews: some View {
        RangedBarChartView(data: _points)
    }
}
