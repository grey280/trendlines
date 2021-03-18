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
    
    let dateAdded: Date
    var value: Int
    var datasetID: DataSet.ID
}

extension DataSetEntry: Codable { }
extension DataSetEntry: MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
extension DataSetEntry: FetchableRecord { }
