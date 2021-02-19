//
//  BarChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct BarChartView<X: Hashable & Comparable>: View {
    struct DataPoint {
        let x: X
        let y: Double
    }
    
    public init(data: [DataPoint], color: Color = .gray) {
        self.data = data.sorted(by: { (a, b) -> Bool in
            a.x < b.x
        })
        self.color = color
    }
    
    let data: [DataPoint]
    let color: Color
    
    var body: some View {
        HStack {
            // todo: y axis
            ForEach(data, id: \.x) { dataPoint in
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(self.color)
                        .frame(width: 20, height: CGFloat(dataPoint.y) * 15.0)
                    
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
        BarChartView<Int>(data: testData)
    }
}
