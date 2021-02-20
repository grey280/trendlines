//
//  ContentView.swift
//  Shared
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct ContentView: View {
    let r: Bool
    
    var body: some View {
        ZStack {
            RangedBarChartView<Int>(data: (0...30).map { RangedBarChartView<Int>.DataPoint(x: $0, yMin: Double($0), yMax: Double($0 + 2) )}, unit: "Stuff", color: .red, hasOverlay: true)
            if r {
                BarChartView<Int>(data: (0...30).map { BarChartView<Int>.DataPoint(x: 30 - $0, y: Double($0) )}, unit: "Things", color: .blue, axisAlignment: .trailing, hasOverlay: true)
            } else {
                LineChartView<Int>(data: (0...30).map { LineChartView<Int>.DataPoint(x: $0, y: Double.random(in: 0..<30.0) )}, unit: "Things", color: .blue, axisAlignment: .trailing, hasOverlay: true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(r: true)
            ContentView(r: false)
        }
    }
}
