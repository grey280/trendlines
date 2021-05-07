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
        let newY = y - yRange.min
        let calculated = CGFloat(newY / (yRange.max - yRange.min)) * source.height
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
                    let height = barHeight(geo.size, y: dataPoint.y)
                    if height > 0 {
                        let y = (geo.size.height - height) + (height / CGFloat(2))
                        ZStack {
                            if (dataPoint.y >= 0) {
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
                        .frame(width: width, height: height)
                        .position(x: x, y: y)
                    }
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
