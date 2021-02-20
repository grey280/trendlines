//
//  BarChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct BarChartView<X: XPoint>: View {
    struct DataPoint {
        let x: X
        let y: Double
    }
    
    public init(
        data: [DataPoint],
        unit: String,
        color: Color = .gray,
        axisAlignment: YAxisView.AxisAlignment = .leading,
        hasOverlay: Bool = false,
        yRange: (min: Double, max: Double)? = nil
    ) {
        self.data = data.sorted(by: { (a, b) -> Bool in
            a.x < b.x
        })
        self.unit = unit
        self.color = color
        self.axisAlignment = axisAlignment
        if let overrideY = yRange {
            self.yRange = overrideY
        } else {
            let ySorted = data.map { $0.y }.sorted()
            self.yRange = (ySorted.first ?? 0.0, ySorted.last ?? 0.0)
        }
        self.hasOverlay = hasOverlay
    }
    
    let data: [DataPoint]
    let color: Color
    let unit: String
    let axisAlignment: YAxisView.AxisAlignment
    let hasOverlay: Bool
    
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
        (source.width - CGFloat(hasOverlay ? (2 * YAxisView.width) : YAxisView.width) - (spacing * CGFloat(data.count))) / CGFloat(data.count)
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
                if axisAlignment == .leading {
                    YAxisView(min: "0", max: .init(format: "%.0f", yRange.max), unit: unit, color: color)
                } else if hasOverlay {
                    Spacer().frame(width: YAxisView.width)
                }
                ForEach(data, id: \.x) { dataPoint in
                    ZStack {
                        PartialRoundedRectangle(top: barWidth(geo.size) / 4)
                            .fill(self.color.opacity(0.4))
                        PartialRoundedRectangle(top: barWidth(geo.size) / 4)
                            .stroke(self.color)//, style: StrokeStyle(lineWidth: 4))
                    }.frame(width: barWidth(geo.size), height: barHeight(geo.size, y: dataPoint.y))
                    
                }
                if axisAlignment == .trailing {
                    YAxisView(min: "0", max: .init(format: "%.0f", yRange.max), unit: unit, color: color)
                } else if hasOverlay {
                    Spacer().frame(width: YAxisView.width)
                }
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static let testData: [BarChartView<Int>.DataPoint] = [
        .init(x: 1, y: 1),
        .init(x: 2, y: 2),
        .init(x: 3, y: 3)
    ]
    
    static var previews: some View {
        Group {
            BarChartView<Int>(data: testData, unit: "Number", axisAlignment: .trailing)
            BarChartView<Int>(data: (0...30).map { BarChartView<Int>.DataPoint(x: $0, y: Double($0) )}, unit: "Things")
        }
    }
}
