//
//  ChartBuilderView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/21/21.
//

import SwiftUI

struct ChartBuilderView: View {
    
    init(_ onSave: @escaping (Chart) -> Void) {
        self.onSave = onSave
        self._chart = State(initialValue: Chart(id: nil, sortNo: 1, source1: DataSource(sourceType: .entries, title: "", color: .gray, chartType: nil), source2: nil))
    }
    init(chart: Chart, _ onSave: @escaping (Chart) -> Void) {
        self.onSave = onSave
        self._chart = State(initialValue: chart)
    }
    
    let onSave: (Chart) -> Void
    
    @State var chart: Chart
    
    var body: some View {
        Form {
            Section(header: Text("Left")) {
                TextField("Title", text: $chart.source1.title)
                ColorPicker("Color", selection: $chart.source1.color)
                SourceTypePicker(sourceType: $chart.source1.sourceType)
            }
            Toggle("Comparison?", isOn: Binding(get: {
                chart.source2 != nil
            }, set: { (val) in
                if (val) {
                    chart.source2 = DataSource(sourceType: .entries, title: "", color: .gray, chartType: nil)
                } else {
                    chart.source2 = nil
                }
            }))
            if (chart.source2 != nil) {
                Section(header: Text("Right")) {
                    <#code#>
                }
            }
        }
    }
}

struct SourceTypePicker: View {
    @Binding var sourceType: DataSourceType
    
    var body: some View {
        Picker("Data Type", selection: $sourceType) {
            Section(header: Text("Custom")) {
                Text("Data Set").tag(DataSourceType.entries)
            }
            Section(header: Text("Body")) {
                Text("Resting Heart Rate").tag(DataSourceType.health(.body(.restingHeartRate)))
                Text("Heart Rate Variability").tag(DataSourceType.health(.body(.heartRateVariability)))
                Text("Heart Rate").tag(DataSourceType.health(.body(.heartRate)))
                Text("Body Mass").tag(DataSourceType.health(.body(.bodyWeight)))
                Text("Lean Body Mass").tag(DataSourceType.health(.body(.leanBodyMass)))
                Text("Body Fat Percentage").tag(DataSourceType.health(.body(.bodyFatPercentage)))
            }
            Section(header: Text("Activity")) {
                Text("Calories Burned").tag(DataSourceType.health(.activity(.activeEnergy)))
                Text("Walk/Run Distance").tag(DataSourceType.health(.activity(.walkRunDistance)))
                Text("Swim Distance").tag(DataSourceType.health(.activity(.swimDistance)))
                Text("Cycling Distance").tag(DataSourceType.health(.activity(.cyclingDistance)))
                Text("Flights Climbed").tag(DataSourceType.health(.activity(.flightsClimbed)))
                Text("Steps").tag(DataSourceType.health(.activity(.steps)))
                Text("Stand Hours").tag(DataSourceType.health(.activity(.standHours)))
                Text("Exercise Time").tag(DataSourceType.health(.activity(.workoutTime)))
            }
            
            #error("Missing nutrition types")
        }
    }
}

struct ChartBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        ChartBuilderView() { _ in }
    }
}
