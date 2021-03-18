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
    }
}

struct SourceBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        SourceBuilderView(source: .constant(DataSource(sourceType: .empty, title: "", color: .blue, chartType: .bar)))
    }
}
