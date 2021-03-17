//
//  SettingsView.swift
//  trendlines
//
//  Created by Grey Patterson on 3/16/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var database: Database
    @State var editMode = EditMode.inactive
    
    @State var editingChart: Chart? = nil
    
    var body: some View {
        List {
            ForEach(database.charts, id: \.id) { chart in
                if let source2 = chart.source2 {
                    HStack(spacing: 2) {
                        ChartTitleView(source: chart.source1)
                        Text(" and ")
                        ChartTitleView(source: source2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingChart = chart
                    }
                } else {
                    HStack {
                        ChartTitleView(source: chart.source1)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingChart = chart
                    }
                }
            }
            .onDelete(perform: onDelete)
            .onMove(perform: onMove)
        }
        .navigationTitle(Text("Settings"))
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, $editMode)
        .sheet(item: $editingChart, content: { chart in
            ChartBuilderView(chart: chart) { updatedChart in
                guard let idx = database.charts.firstIndex(where: {
                    $0.id == updatedChart.id
                }) else {
                    #warning("Missing error handling")
                    return
                }
                database.charts[idx] = updatedChart
                database.saveCharts()
            }
        })

    }
    
    private func onDelete(offsets: IndexSet) {
        database.charts.remove(atOffsets: offsets)
        database.saveCharts()
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        database.charts.move(fromOffsets: source, toOffset: destination)
        database.saveCharts()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
