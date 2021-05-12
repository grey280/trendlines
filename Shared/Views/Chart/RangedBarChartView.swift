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
    
    private static func barHeightPercentage(y: Double, yRange: (min: Double, max:Double)) -> Double {
        let top = yRange.max - y
        let bottom = abs(yRange.max) + abs(yRange.min)
        return top / bottom
    }
    private static func barCenterPointPercentage(yMin: Double, yMax: Double, yRange: (min: Double, max: Double)) -> Double {
        let topLeft = barHeightPercentage(y: yMax, yRange: yRange)
        let topRight = barHeightPercentage(y: yMin, yRange: yRange)
        return (topLeft + topRight) / 2
    }
    
    private static func barHeight(size: CGSize, yMin: Double, yMax: Double, yRange: (min: Double, max: Double)) -> CGFloat {
        let pct = abs(barHeightPercentage(y: yMax, yRange: yRange) - barHeightPercentage(y: yMin, yRange: yRange))
        return CGFloat(pct) * size.height
    }
    private static func yCenter(yMin: Double, yMax: Double, yRange: (min: Double, max: Double), size: CGSize) -> CGFloat {
        let pct = barCenterPointPercentage(yMin: yMin, yMax: yMax, yRange: yRange)
        
        return CGFloat(pct) * size.height
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = barWidth(geo.size)
            let widthStep = spacing + width
            let radius = width / 4
            ForEach(0..<data.count, id: \.self) { index in
                if let dataPoint = data[index] {
                    let x = (CGFloat(index) * widthStep) + (width / CGFloat(2))
                    let height = RangedBarChartView.barHeight(size: geo.size, yMin: dataPoint.yMin ?? dataPoint.y, yMax: dataPoint.yMax ?? dataPoint.y, yRange: yRange)
                    if height > 0 {
                        let y = RangedBarChartView.yCenter(yMin: dataPoint.yMin ?? dataPoint.y, yMax: dataPoint.yMax ?? dataPoint.y, yRange: yRange, size: geo.size)
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
