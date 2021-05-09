//
//  DatabaseDataProvider.swift
//  trendlines
//
//  Created by Grey Patterson on 3/27/21.
//

import Foundation
import Combine
import OSLog

class DatabaseProvider: DataProvider {
    let dataSet: DataSet
    let database: Database
    let mode: DataSourceDisplayMode
    private var updateSubscription: AnyCancellable?
    
    private let logger = Logger(subsystem: "net.twoeighty.trendlines", category: "DatabaseProvider")
    
    
    init?(dataSet: DataSet, database: Database, mode: DataSourceDisplayMode) {
        self.dataSet = dataSet
        self.database = database
        self.mode = mode
        super.init()
        loadData()
    }
    
    func loadData() {
        if updateSubscription == nil {
            self.updateSubscription = database.datasetUpdatedPublisher
                .filter { $0 == self.dataSet.id }
                .sink { _ in
                    self.loadData()
                }
        }
        guard let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) else {
            logger.error("Could not create '30 days ago' date.")
            return
        }
        guard let items = database.queryDataSetEntries(dataSet: dataSet, mode: mode, startDate: startDate) else {
            logger.error("Failed to load items; returning empty.")
            self.points = []
            return
        }
        #warning("Need to fill empty dates with y:0")
        self.points = items
    }
}
