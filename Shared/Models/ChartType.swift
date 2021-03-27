//
//  ChartType.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation
import GRDB

enum ChartType: String, Codable {
    case bar, floatingBar, line
    
    var title: String {
        switch self {
        case .bar:
            return "Bar"
        case .floatingBar:
            return "Floating Bar"
        case .line:
            return "Line"
        }
    }
}

extension ChartType: DatabaseValueConvertible { }
