//
//  ChartTitleView.swift
//  trendlines
//
//  Created by Grey Patterson on 4/15/21.
//

import SwiftUI

struct ChartTitleView: View {
    let source: DataSource
    
    var body: some View {
        Text(source.title)
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 8).fill(source.color.opacity(0.5)))
    }
}

struct ChartTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ChartTitleView(source: DataSource(sourceType: .health(.activity(.activeEnergy)), title: "Active Energy", color: .red, chartType: .bar))
    }
}
