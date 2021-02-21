//
//  ContentView.swift
//  Shared
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var database: Database
    
    var body: some View {
        NavigationView {
            List(database.charts, id: \.id) {
                ChartView(chart: $0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
