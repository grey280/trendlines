//
//  ChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI

fileprivate struct _ChartView: View {
    public init(source: DataSource, overlay: Overlay = .none) {
        self.source = source
        self.overlay = overlay
        
        switch source.sourceType {
        case .entries:
            self._provider = StateObject(wrappedValue: NoopDataProvider())
        case .health(let healthType):
            #if !os(macOS)
            if let health = HealthDataProvider(healthType) {
                self._provider = StateObject(wrappedValue: health)
            } else {
                self._provider = StateObject(wrappedValue: NoopDataProvider())
            }
            #else
            self._provider = StateObject(wrappedValue: NoopDataProvider())
            #endif
        }
    }
    
    @StateObject var provider: DataProvider
    
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
            BarChartView(data: provider.points, unit: source.unitName, color: source.color, axisAlignment: axisAlignment, hasOverlay: hasOverlay)
        case .floatingBar:
            EmptyView()
//            RangedBarChartView(data: <#T##[RangedBarChartView<_>.DataPoint]#>, unit: source.unitName, color: source.color, axisAlignment: axisAlignment, hasOverlay: hasOverlay)
        case .line:
            LineChartView(data: provider.points, unit: source.unitName, color: source.color, axisAlignment: axisAlignment, hasOverlay: hasOverlay)
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
