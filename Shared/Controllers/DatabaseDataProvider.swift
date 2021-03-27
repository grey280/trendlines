//
//  DatabaseDataProvider.swift
//  trendlines
//
//  Created by Grey Patterson on 3/27/21.
//

import Foundation
import OSLog

fileprivate class DatabaseProviderHelpers {
    static let logger = Logger(subsystem: "net.twoeighty.trendlines", category: "DatabaseProvider")
}

class DatabaseProvider: DataProvider {
    let dataSet: DataSet
    let database: Database
    let mode: DataSourceDisplayMode
    
    init?(dataSet: DataSet, database: Database, mode: DataSourceDisplayMode) {
        self.dataSet = dataSet
        self.database = database
        self.mode = mode
    }
    
    
}
