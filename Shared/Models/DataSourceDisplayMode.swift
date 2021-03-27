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

extension DataSourceDisplayMode: DatabaseValueConvertible {
    var databaseValue: DatabaseValue { "".databaseValue }
    
    static func fromDatabaseValue(_ dbValue: DatabaseValue) -> DataSourceDisplayMode? {
        guard let str = String.fromDatabaseValue(dbValue), let data = str.data(using: .utf8) else {
            return nil
        }
        
        return try? Database.jsonConverter.decode(DataSourceDisplayMode.self, from: data)
    }
}
