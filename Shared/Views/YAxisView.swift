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
    
    public init(min: String, max: String, unit: String, alignment: AxisAlignment, color: Color = .gray) {
        self.min = min
        self.max = max
        self.unit = unit
        self.color = color
        self.alignment = alignment
    }
    
    let min: String
    let max: String
    let unit: String
    let alignment: AxisAlignment
    let color: Color
    
    var body: some View {
        GeometryReader { geo in
            let pref = YAxisWidthPreference(width: geo.size.width, alignment: alignment)
            
            VStack(alignment: .center) {
                Text(max).fixedSize(horizontal: true, vertical: false)
                Spacer()
                Text(unit).rotationEffect(.degrees(-90)).fixedSize()
                Spacer()
                Text(min).fixedSize(horizontal: true, vertical: false)
            }
            .foregroundColor(color).font(.footnote)
            .preference(key: YAxisWidthPreferenceKey.self, value: alignment == .leading ? (leading: pref, trailing: nil) : (leading: nil, trailing: pref))
            //        .frame(width: YAxisView.width)
        }
    }
}

struct YAxisView_Previews: PreviewProvider {
    static var previews: some View {
        YAxisView(min: "0", max: "1000", unit: "Things", alignment: .leading)
    }
}

struct YAxisWidthPreference: Equatable {
    let width: CGFloat
    let alignment: YAxisView.AxisAlignment
}

struct YAxisWidthPreferenceKey: PreferenceKey {
    typealias Value = (leading: YAxisWidthPreference?, trailing: YAxisWidthPreference?)

    static var defaultValue: (leading: YAxisWidthPreference?, trailing: YAxisWidthPreference?) = (leading: .init(width: 0, alignment: .leading), trailing: .init(width: 0, alignment: .trailing))

    static func reduce(value: inout (leading: YAxisWidthPreference?, trailing: YAxisWidthPreference?), nextValue: () -> (leading: YAxisWidthPreference?, trailing: YAxisWidthPreference?)) {
        let val = nextValue()
        if let vL = val.leading {
            value.leading = vL
        }
        if let vT = val.trailing {
            value.trailing = vT
        }
    }
}
