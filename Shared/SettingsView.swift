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
            Section(header: Text("Charts")) {
                ForEach(database.charts, id: \.id) { chart in
                    if let source2 = chart.source2 {
                        HStack(spacing: 2) {
                            ChartTitleView(source: chart.source1)
                            Text(" and ")
                            ChartTitleView(source: source2)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editingChart = chart
                        }
                    } else {
                        HStack {
                            ChartTitleView(source: chart.source1)
                            Spacer()
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
            Section(header: Text("Privacy")) {
                NavigationLink("Privacy Policy", destination: Text("Coming soon."))
                #warning("Missing privacy policy")
            }
            Section(header: Text("Pro")) {
                Text("The free version of Trendlines lets you have 3 charts on your dashboard. To have as many as you'd like, purchase the Pro subscription.")
                #warning("Missing unlocks")
                NavigationLink("Unlock Pro", destination: Text("Coming soon."))
                NavigationLink("Restore Purchase", destination: Text("Coming soon."))
            }
        }
        .listStyle(InsetGroupedListStyle())
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
