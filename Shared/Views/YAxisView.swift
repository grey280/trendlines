//
//  YAxisView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct YAxisView: View {
    enum AxisAlignment {
        case leading, trailing
    }
    
    public static let width: CGFloat = 30
    
    public init(min: String, max: String, unit: String, color: Color = .gray) {
        self.min = min
        self.max = max
        self.unit = unit
        self.color = color
    }
    
    let min: String
    let max: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .center) {
            Text(max)
            Spacer()
            Text(unit).rotationEffect(.degrees(-90)).fixedSize()
            Spacer()
            Text(min)
        }.foregroundColor(color).font(.footnote)
        .frame(width: YAxisView.width)
    }
}

struct YAxisView_Previews: PreviewProvider {
    static var previews: some View {
        YAxisView(min: "0", max: "1000", unit: "Things")
    }
}
