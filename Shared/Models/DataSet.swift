//
//  DataSet.swift
//  trendlines
//
//  Created by Grey Patterson on 3/17/21.
//

import Foundation
import GRDB

struct DataSet {
    typealias ID = Int64
    var id: ID?
    
    var name: String
}

extension DataSet: Codable { }
extension DataSet: MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
extension DataSet: FetchableRecord { }
