//
//  BarChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct YAxisView: View {
    public static let width: CGFloat = 30
    
    public init(min: String, max: String, unit: String, alignment: HorizontalAlignment = .trailing, color: Color = .gray) {
        self.min = min
        self.max = max
        self.unit = unit
        self.alignment = alignment
        self.color = color
    }
    
    let min: String
    let max: String
    let unit: String
    let alignment: HorizontalAlignment
    let color: Color
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(max)
            Spacer()
            Text(unit).rotationEffect(.degrees(-90)).fixedSize()
            Spacer()
            Text(min)
        }.foregroundColor(color).font(.footnote)
        .frame(width: YAxisView.width)
    }
}

struct BarChartView<X: Hashable & Comparable>: View {
    struct DataPoint {
        let x: X
        let y: Double
    }
    
    public init(data: [DataPoint], unit: String, color: Color = .gray) {
        self.data = data.sorted(by: { (a, b) -> Bool in
            a.x < b.x
        })
        self.unit = unit
        self.color = color
        let ySorted = data.map { $0.y }.sorted()
        yRange = (ySorted.first ?? 0.0, ySorted.last ?? 0.0)
    }
    
    let data: [DataPoint]
    let color: Color
    let unit: String
    
    private let yRange: (min: Double, max: Double)
    
    var spacing: CGFloat {
        switch data.count {
        case 0..<10:
            return 8
        case 10..<20:
            return 4
        default:
            return 2
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
                YAxisView(min: "0", max: .init(format: "%.0f", yRange.max), unit: unit)
                ForEach(data, id: \.x) { dataPoint in
                    RoundedRectangle(cornerRadius: barWidth(geo.size) / 4)
                        .fill(self.color)
                        .frame(width: barWidth(geo.size), height: barHeight(geo.size, y: dataPoint.y))
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
            BarChartView<Int>(data: testData, unit: "Number")
            BarChartView<Int>(data: (0...30).map { BarChartView<Int>.DataPoint(x: $0, y: Double($0) )}, unit: "Things")
        }
    }
}
