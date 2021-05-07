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
    
    private func position(index: Int, point: DatePoint, source: CGSize) -> CGPoint {
        let barWidth = barWidth(source)
        let x: CGFloat = CGFloat(index) * (spacing + barWidth)
        
        let yTop: CGFloat = CGFloat(yRange.max - (point.yMax ?? point.y))
        let yBottom: CGFloat = CGFloat(yRange.max - yRange.min)
        let yPercentage = yTop / yBottom
        
        let y = yPercentage * source.height
        
        return CGPoint(x: x, y: y)
    }
    
    private func barHeight(_ source: CGSize, y: Double) -> CGFloat {
        let calculated = CGFloat(y / (yRange.max - yRange.min)) * source.height
        if (calculated < 1) {
            return 1
        }
        return calculated
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = barWidth(geo.size)
            let radius = width / 4
            ForEach(0..<data.count) { index in
                if let dataPoint = data[index] {
                    let pos = position(index: index, point: dataPoint, source: geo.size)
                    ZStack {
                        RoundedRectangle(cornerRadius: radius)
                            .fill(self.color.opacity(0.4))
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(self.color)//, style: StrokeStyle(lineWidth: 4))
                    }
                    .frame(width: width, height: barHeight(geo.size, y: (dataPoint.yMax ?? dataPoint.y) - (dataPoint.yMin ?? dataPoint.y)), alignment: .center)
                    .position(x: pos.x, y: pos.y)
                }
            }
        }
    }
}

//struct RangedBarChartView_Previews: PreviewProvider {
//    static let testData: [RangedBarChartView<Int>.DataPoint] = [
//        .init(x: 1, yMin: 1, yMax: 2),
//        .init(x: 2, yMin: 2, yMax: 4),
//        .init(x: 3, yMin: 3, yMax: 6),
//        .init(x: 4, yMin: 1, yMax: 1)
//    ]
//
//    static var previews: some View {
//        Group {
//            RangedBarChartView<Int>(data: testData, unit: "Number", axisAlignment: .trailing)
//            RangedBarChartView<Int>(data: testData, unit: "Number", axisAlignment: .trailing, hasOverlay: true)
//            RangedBarChartView<Int>(data: (0...30).map { RangedBarChartView<Int>.DataPoint(x: $0, yMin: Double($0), yMax: Double($0 + 2) )}, unit: "Things")
//        }
//    }
//}
