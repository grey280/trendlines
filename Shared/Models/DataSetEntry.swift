//
//  DataSetEntry.swift
//  trendlines
//
//  Created by Grey Patterson on 3/17/21.
//

import Foundation
import GRDB

struct DataSetEntry {
    typealias ID = Int64
    var id: ID?
    
    var dateAdded: Date
    var value: Double
    var datasetID: DataSet.ID
    
    enum Columns: String, ColumnExpression {
        case id, dateAdded, value, datasetID
    }
}

extension DataSetEntry: Codable { }
extension DataSetEntry: MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
extension DataSetEntry: FetchableRecord { }
