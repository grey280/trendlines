//
//  ChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI

protocol DataProviderPoint {
    associatedtype X: XPoint
    var x: X { get }
    var y: Double { get }
}

extension DataProviderPoint {
    var lineChart: LineChartView<X>.DataPoint {
        get {
            .init(x: x, y: y)
        }
        
    }
    var barChart: BarChartView<X>.DataPoint {
        get {
            .init(x: x, y: y)
        }
    }
}

protocol DataProvider: ObservableObject {
    associatedtype X: XPoint
    associatedtype Point: DataProviderPoint
    
    var points: [Point] { get }
}

protocol RangedDataProvider: ObservableObject {
    associatedtype X: XPoint
    
    var data: [RangedBarChartView<X>.DataPoint] { get }
}

fileprivate struct _ChartView: View {
    enum Overlay {
        case none, has, `is`
    }
    
    let source: DataSource
    let overlay: Overlay
    
    var axisAlignment: YAxisView.AxisAlignment {
        switch overlay {
        case .none, .has:
            return .leading
        case .is:
            return .trailing
        }
    }
    var hasOverlay: Bool {
        switch overlay {
        case .none:
            return false
        case .has, .is:
            return true
        }
    }
    
    var body: some View {
        switch source.effectiveChartType {
        case .bar:
            BarChartView(data: <#T##[BarChartView<_>.DataPoint]#>, unit: source.unitName, color: source.color, axisAlignment: axisAlignment, hasOverlay: hasOverlay)
        case .floatingBar:
            RangedBarChartView(data: <#T##[RangedBarChartView<_>.DataPoint]#>, unit: source.unitName, color: source.color, axisAlignment: axisAlignment, hasOverlay: hasOverlay)
        case .line:
            LineChartView(data: <#T##[LineChartView<_>.DataPoint]#>, unit: source.unitName, color: source.color, axisAlignment: axisAlignment, hasOverlay: hasOverlay)
        }
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
