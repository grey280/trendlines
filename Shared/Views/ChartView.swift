//
//  ChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI

struct ChartTitleView: View {
    let source: DataSource
    
    var body: some View {
        Text(source.title)
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 8).fill(source.color.opacity(0.5)))
    }
}

fileprivate struct ChartView_Double: View {
    public init(source1: DataSource, source2: DataSource, database: Database) {
        self.database = database
        self.source1 = source1
        
        switch source1.sourceType {
        case .empty:
            self._provider1 = StateObject(wrappedValue: DemoDataProvider())
        case .entries(let sourceID, let mode):
            if let set = database.customDataSets.first(where: {
                $0.id == sourceID
            }), let provider = DatabaseProvider(dataSet: set, database: database, mode: mode) {
                self._provider1 = StateObject(wrappedValue: provider)
            } else {
                self._provider1 = StateObject(wrappedValue: NoopDataProvider())
            }
        case .health(let healthType):
            #if !os(macOS)
            if let health = HealthDataProvider(healthType) {
                self._provider1 = StateObject(wrappedValue: health)
            } else {
                self._provider1 = StateObject(wrappedValue: NoopDataProvider())
            }
            #else
            self._provider = StateObject(wrappedValue: NoopDataProvider())
            #endif
        }
        
        self.source2 = source2
        switch source2.sourceType {
        case .empty:
            self._provider2 = StateObject(wrappedValue: DemoDataProvider())
        case .entries(let sourceID, let mode):
            if let set = database.customDataSets.first(where: {
                $0.id == sourceID
            }), let provider = DatabaseProvider(dataSet: set, database: database, mode: mode) {
                self._provider2 = StateObject(wrappedValue: provider)
            } else {
                self._provider2 = StateObject(wrappedValue: NoopDataProvider())
            }
        case .health(let healthType):
            #if !os(macOS)
            if let health = HealthDataProvider(healthType) {
                self._provider2 = StateObject(wrappedValue: health)
            } else {
                self._provider2 = StateObject(wrappedValue: NoopDataProvider())
            }
            #else
            self._provider2 = StateObject(wrappedValue: NoopDataProvider())
            #endif
        }
    }
    
    @ObservedObject var database: Database
    let source1: DataSource
    let source2: DataSource
    
    @StateObject var provider1: DataProvider
    @StateObject var provider2: DataProvider
    
    func yRange(points: [DatePoint]) -> (min: Double, max: Double) {
        var result = (min: Double.infinity, max: -Double.infinity)
        for point in points {
            let min = point.yMin ?? point.y
            let max = point.yMax ?? point.y
            if (min < result.min) {
                result.min = min
            }
            if (max > result.max) {
                result.max = max
            }
        }
        return result
    }
    
    var body: some View {
        let s1r = yRange(points: provider1.points)
        let s2r = yRange(points: provider2.points)
        
        HStack {
            YAxisView(min: .init(format: "%.0f", s1r.min), max: .init(format: "%.0f", s1r.max), unit: source1.unitName, color: source1.color)
            ZStack {
                switch source1.chartType {
                case .bar:
                    BarChartView(data: provider1.points, color: source1.color, yRange: s1r)
                case .floatingBar:
                    RangedBarChartView(data: provider1.points, color: source1.color, yRange: s1r)
                case .line:
                    LineChartView(data: provider1.points, color: source1.color, yRange: s1r)
                }
                switch source2.chartType {
                case .bar:
                    BarChartView(data: provider2.points, color: source2.color, yRange: s2r)
                case .floatingBar:
                    RangedBarChartView(data: provider2.points, color: source2.color, yRange: s2r)
                case .line:
                    LineChartView(data: provider2.points, color: source2.color, yRange: s2r)
                }
            }
            YAxisView(min: .init(format: "%.0f", s2r.min), max: .init(format: "%.0f", s2r.max), unit: source2.unitName, color: source2.color)
        }
    }
}

fileprivate struct ChartView_Single: View {
    public init(source: DataSource, database: Database) {
        self.database = database
        self.source = source
        
        switch source.sourceType {
        case .empty:
            self._provider = StateObject(wrappedValue: DemoDataProvider())
        case .entries(let sourceID, let mode):
            if let set = database.customDataSets.first(where: {
                $0.id == sourceID
            }), let provider = DatabaseProvider(dataSet: set, database: database, mode: mode) {
                self._provider = StateObject(wrappedValue: provider)
            } else {
                self._provider = StateObject(wrappedValue: NoopDataProvider())
            }
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
    
    @ObservedObject var database: Database
    let source: DataSource
    
    @StateObject var provider: DataProvider
    
    func yRange(points: [DatePoint]) -> (min: Double, max: Double) {
        var result = (min: Double.infinity, max: -Double.infinity)
        for point in points {
            let min = point.yMin ?? point.y
            let max = point.yMax ?? point.y
            if (min < result.min) {
                result.min = min
            }
            if (max > result.max) {
                result.max = max
            }
        }
        return result
    }
    
    var body: some View {
        let range = yRange(points: provider.points)
        
        HStack {
            YAxisView(min: .init(format: "%.0f", range.min), max: .init(format: "%.0f", range.max), unit: source.unitName, color: source.color)
            switch source.chartType {
            case .bar:
                BarChartView(data: provider.points, color: source.color, yRange: range)
            case .floatingBar:
                RangedBarChartView(data: provider.points, color: source.color, yRange: range)
            case .line:
                LineChartView(data: provider.points, color: source.color, yRange: range)
            }
            
        }
    }
}

struct ChartView: View {
    @EnvironmentObject var database: Database
    let chart: Chart
    
    var body: some View {
        VStack(alignment: .leading) {
            if let source2 = chart.source2 {
                HStack(spacing: 2) {
                    ChartTitleView(source: chart.source1)
                    Text(" and ")
                    ChartTitleView(source: source2)
                }
                ChartView_Double(source1: chart.source1, source2: source2, database: database)
            } else {
                HStack {
                    ChartTitleView(source: chart.source1)
                }
                ChartView_Single(source: chart.source1, database: database)
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        if let db = Database() {
            ChartView(chart: Chart(id: nil, sortNo: 1, source1: DataSource(sourceType: .health(.activity(.activeEnergy)), title: "Active Energy", color: .red, chartType: .bar), source2: nil))
                .environmentObject(db)
        } else {
            EmptyView()
        }
    }
}
