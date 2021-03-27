//
//  ChartTypePickerView.swift
//  trendlines
//
//  Created by Grey Patterson on 3/25/21.
//

import SwiftUI

fileprivate struct ChartTypePickerItemView: View {
    let type: ChartType
    @Binding var selectedType: ChartType
    let provider: DataProvider
    let color: Color
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // TODO: Needs some accessilbity hinting to indicate active state
        HStack {
            switch type {
            case .bar:
                BarChartView(data: provider.points, unit: "Data", color: color, axisAlignment: .leading, hasOverlay: false).padding()
            case .floatingBar:
                RangedBarChartView(data: provider.points, unit: "Data", color: color, axisAlignment: .leading, hasOverlay: false).padding()
            case .line:
                LineChartView(data: provider.points, unit: "Data", color: color, axisAlignment: .leading, hasOverlay: false).padding()
            }
            Spacer()
            if (type == selectedType) {
                Image(systemName: "checkmark.circle.fill")
            } else {
                Image(systemName: "checkmark.circle")
            }
        }
        .frame(minHeight: 200)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedType = type
            presentationMode.wrappedValue.dismiss()
        }
    }
}

fileprivate struct ChartTypePickerListView: View {
    @Binding var chartType: ChartType
    @StateObject var provider = DemoDataProvider()
    let color: Color
    
    var body: some View {
        List {
            ChartTypePickerItemView(type: .bar, selectedType: $chartType, provider: provider, color: color)
            ChartTypePickerItemView(type: .floatingBar, selectedType: $chartType, provider: provider, color: color)
            ChartTypePickerItemView(type: .line, selectedType: $chartType, provider: provider, color: color)
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(Text("Chart Type"))
    }
}

struct ChartTypePickerView: View {
    @Binding var chartType: ChartType
    let  color: Color
    
    var body: some View {
        NavigationLink(destination: ChartTypePickerListView(chartType: $chartType, color: color)) {
            Text(chartType.title)
        }
    }
}

struct ChartTypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ChartTypePickerListView(chartType: .constant(.bar), color: .blue)
    }
}
