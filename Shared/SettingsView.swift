//
//  SettingsView.swift
//  trendlines
//
//  Created by Grey Patterson on 3/16/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var database: Database
    
    var body: some View {
        NavigationView {
            List {
                ForEach(database.charts, id: \.id) { chart in
                    if let source2 = chart.source2 {
                        HStack(spacing: 2) {
                            ChartTitleView(source: chart.source1)
                            Text(" and ")
                            ChartTitleView(source: source2)
                        }
                    } else {
                        HStack {
                            ChartTitleView(source: chart.source1)
                        }
                    }
                }
                .onDelete(perform: onDelete)
                .onMove(perform: onMove)
            }
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        let charts = offsets.map {
            database.charts[$0]
        }
        for chart in charts {
            do {
                try database.remove(chart: chart)
            } catch {
                #warning("Missing error handling.")
            }
        }
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
