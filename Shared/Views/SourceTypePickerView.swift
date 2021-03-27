//
//  SourceTypePickerView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/21/21.
//

import SwiftUI

fileprivate struct SourceTypeNewCustomItemView: View {
    @Binding var selectedType: DataSourceType
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var set = DataSet(id: nil, name: "")
    
    let onDismiss: (() -> Void)?
    
    @EnvironmentObject var database: Database
    
    var body: some View {
        Form {
            TextField("Name", text: $set.name)
            Button("Save") {
                if let saved = database.add(dataSet: set), let id = saved.id {
                    selectedType = .entries(datasetID: id, mode: .average)
                    onDismiss?()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }.navigationTitle("New...")
    }
}

fileprivate struct SourceTypePickerItemView: View {
    init(type: DataSourceType, selectedType: Binding<DataSourceType>, database: Database? = nil) {
        self.type = type
        self._selectedType = selectedType
        if case .entries(let id,_) = type {
            if let set = database?.customDataSets.first(where: {
                $0.id == id
            }) {
                self.dataSet = set
            } else {
                self.dataSet = nil
            }
        } else {
            self.dataSet = nil
        }
    }
    
    let type: DataSourceType
    let dataSet: DataSet?
    @Binding var selectedType: DataSourceType
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // TODO: Needs some accessibility hinting to indicate activate state
        HStack {
            if let set = dataSet {
                Text(set.name)
            } else {
                Text(type.title)
            }
            Spacer()
            if (type == selectedType) {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedType = type
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SourceTypePickerView: View {
    @Binding var sourceType: DataSourceType
    @EnvironmentObject var database: Database
    
    var body: some View {
        NavigationLink(destination: SourceTypePickerListView(sourceType: $sourceType)) {
            if case .entries(let id,_) = sourceType {
                if let set = database.customDataSets.first(where: {
                    $0.id == id
                }) {
                    Text(set.name)
                } else {
                    Text(sourceType.title)
                }
            } else {
                Text(sourceType.title)
            }
        }
    }
}

fileprivate struct SourceTypePickerListView: View {
    @Binding var sourceType: DataSourceType
    @EnvironmentObject var database: Database
    
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section(header: Text("Custom")) {
                ForEach(database.customDataSets, id: \.id) { dataSet in
                    if let id = dataSet.id {
                        if case .entries(_, let mode) = sourceType {
                            SourceTypePickerItemView(type: .entries(datasetID: id, mode: mode), selectedType: $sourceType, database: database)
                        } else {
                            SourceTypePickerItemView(type: .entries(datasetID: id, mode: .average), selectedType: $sourceType, database: database)
                        }
                    }
                }
                NavigationLink(destination: SourceTypeNewCustomItemView(selectedType: $sourceType, onDismiss: {
                    database.loadDatasets()
                })) {
                    Text("New...")
                }
            }
            Section(header: Text("Body")) {
                ForEach(DataSourceType.HealthSource.BodySource.allCases, id: \.rawValue) {
                    SourceTypePickerItemView(type: .health(.body($0)), selectedType: $sourceType)
                }
            }
            Section(header: Text("Activity")) {
                ForEach(DataSourceType.HealthSource.ActivitySource.allCases, id: \.rawValue) {
                    SourceTypePickerItemView(type: .health(.activity($0)), selectedType: $sourceType)
                }
            }
            Section(header: Text("Nutrition")) {
                SourceTypePickerItemView(type: .health(.nutrition(.calories)), selectedType: $sourceType)
                SourceTypePickerItemView(type: .health(.nutrition(.water)), selectedType: $sourceType)
                SourceTypePickerItemView(type: .health(.nutrition(.carbohydrates)), selectedType: $sourceType)
                SourceTypePickerItemView(type: .health(.nutrition(.fat)), selectedType: $sourceType)
                SourceTypePickerItemView(type: .health(.nutrition(.protein)), selectedType: $sourceType)
                SourceTypePickerItemView(type: .health(.nutrition(.caffeine)), selectedType: $sourceType)
                SourceTypePickerItemView(type: .health(.nutrition(.sugar)), selectedType: $sourceType)
            }
            Section(header: Text("Vitamins")) {
                ForEach(DataSourceType.HealthSource.NutritionSource.VitaminSource.allCases, id: \.rawValue) {
                    SourceTypePickerItemView(type: .health(.nutrition(.vitamin($0))), selectedType: $sourceType)
                }
            }
            Section(header: Text("Minerals")) {
                ForEach(DataSourceType.HealthSource.NutritionSource.MineralSource.allCases, id: \.rawValue) {
                    SourceTypePickerItemView(type: .health(.nutrition(.mineral($0))), selectedType: $sourceType)
                }
            }
            Section(header: Text("Micronutrients")) {
                ForEach(DataSourceType.HealthSource.NutritionSource.MicronutrientSource.allCases, id: \.rawValue) {
                    SourceTypePickerItemView(type: .health(.nutrition(.micronutrient($0))), selectedType: $sourceType)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(Text("Data Source"))
    }
}


struct SourceTypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        if let database = Database() {
            SourceTypePickerView(sourceType: .constant(DataSourceType.empty))
                .environmentObject(database)
        } else {
            EmptyView()
        }
    }
}
