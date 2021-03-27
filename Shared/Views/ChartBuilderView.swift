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
        self._chart = State(initialValue: Chart(id: nil, sortNo: 1, source1: DataSource(sourceType: .empty, title: "", color: .gray, chartType: .bar), source2: nil))
        self._hasSource2 = State(initialValue: false)
    }
    init(chart: Chart, _ onSave: @escaping (Chart) -> Void) {
        self.onSave = onSave
        self._chart = State(initialValue: chart)
        self._hasSource2 = State(initialValue: chart.source2 != nil)
    }
    
    let onSave: (Chart) -> Void
    
    @State var chart: Chart
    @State var hasSource2: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Left")) {
                    SourceBuilderView(source: $chart.source1)
                }
                Toggle("Comparison?", isOn: $hasSource2)
                if hasSource2 {
                    if let source2 = Binding($chart.source2) {
                        Section(header: Text("Right")) {
                            SourceBuilderView(source: source2)
                        }
                    }
                }
            }.navigationTitle(chart.id == nil ? "Create Chart" : "Edit Chart")
            .onChange(of: hasSource2, perform: { _ in
                if (self.hasSource2 && self.chart.source2 == nil) {
                    self.chart.source2 = DataSource(sourceType: .empty, title: "", color: .blue, chartType: .bar)
                }
            })
            .navigationBarItems(trailing: Button("Save", action: {
                var chart = self.chart
                if !hasSource2 {
                    chart.source2 = nil
                }
                onSave(chart)
                presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct ChartBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        ChartBuilderView() { _ in }
    }
}
