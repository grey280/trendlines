//
//  RangedBarChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct RangedBarChartView<X: XPoint>: View {
    struct DataPoint {
        let x: X
        let yMin: Double
        let yMax: Double
    }
    
    public init(data: [DataPoint], unit: String, color: Color = .gray, axisAlignment: YAxisView.AxisAlignment = .leading) {
        self.data = data.sorted(by: { (a, b) -> Bool in
            a.x < b.x
        })
        self.unit = unit
        self.color = color
        self.axisAlignment = axisAlignment
        let ySorted = data.flatMap { [$0.yMin, $0.yMax] }.sorted()
        yRange = (ySorted.first ?? 0.0, ySorted.last ?? 0.0)
    }
    
    let data: [DataPoint]
    let color: Color
    let unit: String
    let axisAlignment: YAxisView.AxisAlignment
    
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
        (source.width - CGFloat(30) - (spacing * CGFloat(data.count))) / CGFloat(data.count)
    }
    private func barHeight(_ source: CGSize, y: Double) -> CGFloat {
        CGFloat(y / yRange.max) * source.height
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .bottom, spacing: spacing) {
                if axisAlignment == .leading {
                    YAxisView(min: "0", max: .init(format: "%.0f", yRange.max), unit: unit)
                }
                ForEach(data, id: \.x) { dataPoint in
                    ZStack {
                        RoundedRectangle(cornerRadius: barWidth(geo.size) / 4)
                            .fill(self.color.opacity(0.5))
                        RoundedRectangle(cornerRadius: barWidth(geo.size) / 4)
                            .stroke(self.color)//, style: StrokeStyle(lineWidth: 4))
                    }.frame(width: barWidth(geo.size), height: barHeight(geo.size, y: dataPoint.yMax - dataPoint.yMin)).padding(.bottom, barHeight(geo.size, y: dataPoint.yMin))
                    
                }
                if axisAlignment == .trailing {
                    YAxisView(min: "0", max: .init(format: "%.0f", yRange.max), unit: unit)
                }
            }
        }
    }
}

struct RangedBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        RangedBarChartView()
    }
}
