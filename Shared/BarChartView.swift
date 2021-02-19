//
//  BarChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct BarChartView<X: Comparable, Y: Numeric>: View {
    struct DataPoint<X: Comparable, Y: Numeric> {
        let x: X
        let y: Y
    }
    
    let data: [DataPoint<X,Y>]
    
    private var xRange: (X, X)? {
        guard data.count > 0 else {
            return nil
        }
        let sorted = data.map { $0.x }.sorted()
        return (sorted.first!, sorted.last ?? sorted.first!)
    }
    
    var body: some View {
        HStack {
            // todo: y axis
            
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static let testData: [BarChartView<Int, Int>.DataPoint<Int, Int>] = [
        .init(x: 1, y: 1),
        .init(x: 2, y: 2),
        .init(x: 3, y: 3)
    ]
    
    static var previews: some View {
        BarChartView<Int,Int>(data: testData)
    }
}
