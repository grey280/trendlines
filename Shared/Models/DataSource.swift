//
//  DataSource.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI
import GRDB

struct DataSource {
    typealias ID = Int64
    var id: ID?
    
    var sourceType: DataSourceType
    var title: String?
    var color: Color
    var chartType: ChartType?
}

extension DataSource: Codable { }

extension DataSource: MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
