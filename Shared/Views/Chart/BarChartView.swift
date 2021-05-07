//
//  BarChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct BarChartView: View {
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
            let ySorted = data.map { $0.y }.sorted()
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
        let calculated = CGFloat(y / yRange.max) * source.height
        if (calculated < 10) {
            return 10
        }
        return calculated
    }
    private func position(index: Int, point: DatePoint, source: CGSize) -> CGPoint {
        let barWidth = barWidth(source)
        let x: CGFloat = CGFloat(index) * (spacing + barWidth)
        
        let yTop: CGFloat = CGFloat(yRange.max - point.y)
        let yBottom: CGFloat = CGFloat(yRange.max - yRange.min)
        let yPercentage = yTop / yBottom
        
        let y = yPercentage * source.height
        
        return CGPoint(x: x, y: y)
    }
    
    var body: some View {
        GeometryReader { geo in
            let width = barWidth(geo.size)
            let radius = width / 4
            ForEach(0..<data.count) { index in
                if let dataPoint = data[index] {
                    let pos = position(index: index, point: dataPoint, source: geo.size)
                    ZStack {
                        if (dataPoint.y > 0) {
                            PartialRoundedRectangle(top: radius)
                                .fill(self.color.opacity(0.4))
                            PartialRoundedRectangle(top: radius)
                                .stroke(self.color)//, style: StrokeStyle(lineWidth: 4))
                        } else {
                            PartialRoundedRectangle(bottom: radius)
                                .fill(self.color.opacity(0.4))
                            PartialRoundedRectangle(bottom: radius)
                                .stroke(self.color)//, style: StrokeStyle(lineWidth: 4))
                        }
                    }
                    .frame(width: width, height: barHeight(geo.size, y: dataPoint.y), alignment: .center)
                    .position(x: pos.x, y: pos.y)
                }
            }
        }
    }
}

//struct BarChartView_Previews: PreviewProvider {
//    static let testData: [DatePoint] = [
//        .init(1, y: 1),
//        .init(2, y: 2),
//        .init(3, y: 3)
//    ]
//    
//    static var previews: some View {
//        Group {
//            BarChartView<Int>(data: testData, unit: "Number", axisAlignment: .trailing)
//            BarChartView<Int>(data: (0...30).map { DatePoint($0, y: Double($0) )}, unit: "Things")
//        }
//    }
//}
