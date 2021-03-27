//
//  DataSetEntryCreatorView.swift
//  trendlines
//
//  Created by Grey Patterson on 3/26/21.
//

import SwiftUI

struct DataSetEntryCreatorView: View {
    init?(database: Database, dataSet: DataSet, onDismiss: (() -> Void)? = nil) {
        _database = ObservedObject(wrappedValue: database)
        self.dataSet = dataSet
        guard let id = dataSet.id else {
            return nil
        }
        _entry = State(initialValue: DataSetEntry(id: nil, dateAdded: Date(), value: 0, datasetID: id))
        self.onDismiss = onDismiss
    }
    
    @ObservedObject var database: Database
    let dataSet: DataSet
    
    let onDismiss: (() -> Void)?
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    @State var entry: DataSetEntry
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            DatePicker("Date", selection: $entry.dateAdded)
//            TextField("Value", value: $entry.value, formatter: formatter) // this doesn't work! Thanks, Apple.
            TextField("Value", text: Binding(get: {
                formatter.string(from: NSNumber(value: entry.value)) ?? "0"
            }, set: { (newValue) in
                if let asNumber = formatter.number(from: newValue) {
                    entry.value = asNumber.doubleValue
                }
            }))
                .keyboardType(.decimalPad)
            Button("Add") {
                if (database.add(entry: entry)) {
                    onDismiss?()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct DataSetEntryCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        if let database = Database() {
            DataSetEntryCreatorView(database: database, dataSet: DataSet(id: nil, name: "Test"))
        } else {
            EmptyView()
        }
    }
}
