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
}

extension ChartType: DatabaseValueConvertible { }
