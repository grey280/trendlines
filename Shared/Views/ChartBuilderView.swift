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
        self._chart = State(initialValue: Chart(id: nil, sortNo: 1, source1: DataSource(sourceType: .entries, title: nil, color: .gray, chartType: nil), source2: nil))
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
                <#code#>
            }
            Toggle("Comparison?", isOn: Binding(get: {
                chart.source2 != nil
            }, set: { (val) in
                if (val) {
                    chart.source2 = DataSource(sourceType: .entries, title: nil, color: .gray, chartType: nil)
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

struct ChartBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        ChartBuilderView() { _ in }
    }
}
