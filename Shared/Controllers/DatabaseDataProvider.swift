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
        guard var items = database.queryDataSetEntries(dataSet: dataSet, mode: mode, startDate: startDate) else {
            logger.error("Failed to load items; returning empty.")
            self.points = []
            return
        }
        var runningDate = startDate
        while runningDate < Date() {
            // does this date exist in the list?
            if (!items.contains(where: { datePoint in
                Calendar.current.compare(datePoint.x, to: runningDate, toGranularity: .day) == .orderedSame
            })) {
                items.append(DatePoint(runningDate, y: 0))
            }
            runningDate = Calendar.current.date(byAdding: .day, value: 1, to: runningDate)!
        }
        self.points = items
    }
}
