//
//  CustomDataSetView.swift
//  trendlines
//
//  Created by Grey Patterson on 3/26/21.
//

import SwiftUI

struct CustomDataSetView: View {
    @ObservedObject var database: Database
    let dataSet: DataSet
    
    @State var entries: [DataSetEntry] = []
    
    var body: some View {
        List {
            ForEach(entries, id: \.id) { entry in
                HStack {
                    Text("\(entry.dateAdded)")
                    Spacer()
                    Text("\(entry.value)")
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(dataSet.name)
        .navigationBarItems(leading: EditButton())
        .onAppear(perform: loadEntries)
    }
    
    func loadEntries() {
        if let entries = database.loadDataSetEntries(dataSet: dataSet) {
            self.entries = entries
        }
    }
    
    func delete(indexSet: IndexSet) {
        let entries = indexSet.map { self.entries[$0] }
        if database.delete(entries: entries) {
            loadEntries()
        }
    }
}

struct CustomDataSetView_Previews: PreviewProvider {
    static var previews: some View {
        if let database = Database() {
            CustomDataSetView(database: database, dataSet: DataSet(id: nil, name: "Test"))
        } else {
            EmptyView()
        }
        
    }
}
