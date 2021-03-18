//
//  SourceTypePickerView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/21/21.
//

import SwiftUI

fileprivate struct SourceTypePickerItemView: View {
    let type: DataSourceType
    @Binding var selectedType: DataSourceType
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // TODO: Needs some accessibility hinting to indicate activate state
        HStack {
            Text(type.title)
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
    
    var body: some View {
        NavigationLink(destination: SourceTypePickerListView(sourceType: $sourceType)) {
            Text(sourceType.title)
        }
    }
}

fileprivate struct SourceTypePickerListView: View {
    @Binding var sourceType: DataSourceType
    
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section(header: Text("Custom")) {
                #warning("Not implemented")
                Text("Not implemented")
//                SourceTypePickerItemView(type: .entries, selectedType: $sourceType)
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
        }//.onChange(of: sourceType) {
        //    presentationMode.wrappedValue.dismiss()
        //}
        .listStyle(GroupedListStyle())
        .navigationTitle(Text("Data Source"))
    }
}


struct SourceTypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        SourceTypePickerView(sourceType: .constant(DataSourceType.empty))
    }
}
