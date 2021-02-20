//
//  ChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI

fileprivate struct _ChartView: View {
    enum Overlay {
        case none, has, `is`
    }
    
    let source: DataSource
    let overlay: Overlay
    
    var body: some View {
        EmptyView() // TODO: Implement
    }
}

struct ChartView: View {
    let chart: Chart
    
    var body: some View {
        if let source2 = chart.source2 {
            ZStack {
                _ChartView(source: chart.source1, overlay: .has)
                _ChartView(source: source2, overlay: .is)
            }
        } else {
            _ChartView(source: chart.source1, overlay: .none)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(chart: Chart(id: nil, sortNo: 1, source1: DataSource(sourceType: .health(.activity(.activeEnergy)), title: "Active Energy", color: .red, chartType: .bar), source2: nil))
    }
}
