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
    
    @State var showingExporter = false
    @State var showingImporter = false
    @State var exportDocument: DataSetExport? = nil
    @State var fileResult: String? = nil
    @State var hasFileResult = false
    
    @Environment(\.presentationMode) var presentationMode
    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Settings")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    addingEntry.toggle()
                } label: {
                    Image(systemName: "plus").accessibility(hint: Text("Add an entry"))
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    exportDocument = DataSetExport(entries: entries)
                    showingExporter = true
                } label: {
                    Image(systemName: "square.and.arrow.up").accessibility(hint: Text("Export entries"))
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showingImporter = true
                } label: {
                    Image(systemName: "square.and.arrow.down").accessibility(hint: Text("Import entries"))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $addingEntry) {
            DataSetEntryCreatorView(database: database, dataSet: dataSet) {
                loadEntries()
            }
        }
        .alert(isPresented: $hasFileResult, content: {
            Alert(title: Text(fileResult ?? "Something went wrong."))
        })
        .fileExporter(isPresented: $showingExporter, document: exportDocument, contentType: .commaSeparatedText) { result in
            switch result {
            case .success:
                fileResult = "Entries exported!"
            case .failure(let error):
                fileResult = error.localizedDescription
            }
            hasFileResult = true
        }
        .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.commaSeparatedText]) { result in
            do {
                
            } catch {
                fileResult = error.localizedDescription
            }
            hasFileResult = true
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
