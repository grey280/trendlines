//
//  SourceBuilderView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/21/21.
//

import SwiftUI

struct SourceBuilderView: View {
    @Binding var source: DataSource
    
    var body: some View {
        TextField("Title", text: $source.title)
        ColorPicker("Color", selection: $source.color)
        SourceTypePickerView(sourceType: $source.sourceType)
        if case .entries(let setID, let mode) = source.sourceType {
            Picker("Data Mode", selection: Binding(get: {
                mode
            }, set: { (newMode) in
                self.source.sourceType = .entries(datasetID: setID, mode: newMode)
            })) {
                Text("Average").tag(DataSourceDisplayMode.average)
                Text("Count").tag(DataSourceDisplayMode.count)
                Text("Sum").tag(DataSourceDisplayMode.sum)
                Text("Min/Max").tag(DataSourceDisplayMode.minMax)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        ChartTypePickerView(chartType: $source.chartType, color: source.color)
    }
}

struct SourceBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        SourceBuilderView(source: .constant(DataSource(sourceType: .empty, title: "", color: .blue, chartType: .bar)))
    }
}
