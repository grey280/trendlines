//
//  ContentView.swift
//  Shared
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var database: Database
    
    @State var showingAdd = false
    
    var body: some View {
        NavigationView {
            List(database.charts, id: \.id) {
                ChartView(chart: $0)
            }
                .navigationTitle("Dashboard")
            .navigationBarItems(leading: Button(action: {
                showingAdd.toggle()
            }, label: {
                Image(systemName: "plus")
            }), trailing: NavigationLink(destination: Text("Settings!"), label: {
                Image(systemName: "gear")
            }))
        }.sheet(isPresented: $showingAdd) { 
            Text("Creator")
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
