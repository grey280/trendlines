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
        unit: String,
        color: Color = .gray,
        yRange: (min: Double, max: Double)? = nil
    ) {
        self.data = data.sorted(by: { (a, b) -> Bool in
            a.x < b.x
        })
        self.unit = unit
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
    let unit: String
    
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
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .bottom, spacing: spacing) {
                ForEach(data, id: \.x) { dataPoint in
                    ZStack {
                        PartialRoundedRectangle(top: barWidth(geo.size) / 4)
                            .fill(self.color.opacity(0.4))
                        PartialRoundedRectangle(top: barWidth(geo.size) / 4)
                            .stroke(self.color)//, style: StrokeStyle(lineWidth: 4))
                    }.frame(width: barWidth(geo.size), height: barHeight(geo.size, y: dataPoint.y))
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
