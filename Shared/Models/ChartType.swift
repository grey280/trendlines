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

extension ChartType: DatabaseValueConvertible {
    var databaseValue: DatabaseValue { "".databaseValue }
    
    static func fromDatabaseValue(_ dbValue: DatabaseValue) -> ChartType? {
        guard let str = String.fromDatabaseValue(dbValue), let data = str.data(using: .utf8) else {
            return nil
        }
        
        return try? Database.jsonConverter.decode(ChartType.self, from: data)
    }
}
