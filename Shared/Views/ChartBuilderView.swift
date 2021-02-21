//
//  ChartBuilderView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/21/21.
//

import SwiftUI

struct ChartBuilderView: View {
    
    let onSave: (Chart) -> Void
    
    @State var chart = Chart(id: nil, sortNo: 1, source1: DataSource(sourceType: .entries, title: nil, color: .gray, chartType: nil), source2: nil)
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ChartBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        ChartBuilderView() { _ in }
    }
}
