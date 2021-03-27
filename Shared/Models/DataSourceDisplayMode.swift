//
//  DataSourceDisplayMode.swift
//  trendlines
//
//  Created by Grey Patterson on 3/27/21.
//

import Foundation
import GRDB

enum DataSourceDisplayMode: String, Codable, Hashable {
    case count, sum, average, minMax
}

extension DataSourceDisplayMode: DatabaseValueConvertible {}
