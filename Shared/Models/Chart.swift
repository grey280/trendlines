//
//  Chart.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation
import GRDB

struct Chart {
    typealias ID = Int64
    var id: ID?
    
    var sortNo: Int64
    var source1: DataSource
    var source2: DataSource?
}

extension Chart: Codable { }
extension Chart: MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
extension Chart: FetchableRecord { }
extension Chart: TableRecord { }
