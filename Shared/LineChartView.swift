//
//  LineChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct LineChart<X: XPoint>: Shape {
    let data: [LineChartView<X>.DataPoint]
    let yRange: (min: Double, max: Double)
    
    // step size to go from an x point to the next x point
    func xStep(in width: CGFloat) -> CGFloat {
        // need to have one step for each data point (technically we'll have .5 leading and .5 trailing, but that adds up to 1!)
        // leave space for a radius-1 circle at each location
        (width / CGFloat(data.count)) - CGFloat(2 * data.count)
    }
    
    // y coordinates for the given point
    func yLocation(in rect: CGRect, dataPoint: LineChartView<X>.DataPoint) -> CGFloat {
        <#code#>
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = data.first else {
            return path
        }
        path.move(to: CGPoint(x: rect.minX, y: yLocation(in: rect, dataPoint: first)))
    }
}

struct LineChartView<X: XPoint>: View {
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
                LineChart<X>(data: data, yRange: yRange).stroke(color)
                if axisAlignment == .trailing {
                    YAxisView(min: "0", max: .init(format: "%.0f", yRange.max), unit: unit, color: color)
                } else if hasOverlay {
                    Spacer().frame(width: YAxisView.width)
                }
            }
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static let testData: [LineChartView<Int>.DataPoint] = [
        .init(x: 1, y: 1),
        .init(x: 2, y: 2),
        .init(x: 3, y: 3)
    ]
    
    static var previews: some View {
        Group {
            LineChartView<Int>(data: testData, unit: "Number", axisAlignment: .trailing)
            LineChartView<Int>(data: (0...30).map { LineChartView<Int>.DataPoint(x: $0, y: Double($0) )}, unit: "Things")
        }
    }
}
