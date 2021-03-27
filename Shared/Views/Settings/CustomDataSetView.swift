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
    @State var addingEntry = false
    
    var body: some View {
        List {
            ForEach(entries, id: \.id) { entry in
                HStack {
                    Text(entry.dateAdded, style: .date)
                    Spacer()
                    Text("\(entry.value)")
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(dataSet.name)
        .onAppear(perform: loadEntries)
        .navigationBarItems(trailing: Button {
            addingEntry.toggle()
        } label: {
            Image(systemName: "plus").accessibility(hint: Text("Add an entry"))
        })
        .sheet(isPresented: $addingEntry) {
            DataSetEntryCreatorView(database: database, dataSet: dataSet) {
                loadEntries()
            }
        }
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
