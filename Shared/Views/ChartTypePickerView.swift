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
    
    @Environment(\.presentationMode) var presentationMode
    
    var typeTitle: String {
        switch type {
        case .bar:
            return "Bar"
        case .floatingBar:
            return "Floating Bar"
        case .line:
            return "Line"
        }
    }
    
    var body: some View {
        // TODO: Needs some accessilbity hinting to indicate active state
        VStack {
            HStack {
                Text(typeTitle)
                Spacer()
                if (type == selectedType) {
                    Image(systemName: "checkmark")
                }
            }
            switch type {
            case .bar:
                BarChartView(data: provider.points, unit: "Data", color: .blue, axisAlignment: .leading, hasOverlay: false)
            case .floatingBar:
                RangedBarChartView(data: provider.points, unit: "Data", color: .blue, axisAlignment: .leading, hasOverlay: false)
            case .line:
                LineChartView(data: provider.points, unit: "Data", color: .blue, axisAlignment: .leading, hasOverlay: false)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedType = type
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ChartTypePickerView: View {
    @Binding var chartType: ChartType
    @StateObject var provider = DemoDataProvider()
    
    var body: some View {
        List {
            ChartTypePickerItemView(type: .bar, selectedType: $chartType, provider: provider)
            ChartTypePickerItemView(type: .floatingBar, selectedType: $chartType, provider: provider)
            ChartTypePickerItemView(type: .line, selectedType: $chartType, provider: provider)
        }
    }
}

struct ChartTypePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ChartTypePickerView(chartType: .constant(.bar))
    }
}
