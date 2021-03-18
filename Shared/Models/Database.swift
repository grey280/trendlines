//
//  Database.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Combine
import Foundation
import OSLog
import GRDB

class Database: ObservableObject {
    @Published var charts: [Chart] = []
    
    private let logger: Logger
    private let dbQueue: DatabaseQueue
    
    init?() {
        logger = Logger(subsystem: "net.twoeighty.trendlines", category: "Database")
        guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            logger.critical("Could not get document directory URL")
            return nil
        }
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        } catch {
            logger.critical("Could not create database directory: \(error.localizedDescription, privacy: .public)")
            return nil
        }
        url.appendPathComponent("database.sqlite")
        do {
            dbQueue = try DatabaseQueue(path: url.absoluteString)
        } catch {
            logger.critical("Could not create database: \(error.localizedDescription, privacy: .public)")
            return nil
        }
        do {
            try initializeDatabase()
        } catch {
            logger.critical("Could not configure database: \(error.localizedDescription, privacy: .public)")
            return nil
        }
        loadCharts()
    }
    
    private func initializeDatabase() throws {
        try dbQueue.write { db in
            #warning("this schema is completely wrong")
            // dataset: id, name
            // datasetEntry: id, dateAdded, value(int), datasetId
            // chart: see Chart.Columns
            
            
            try db.create(table: Chart.databaseTableName, ifNotExists: true, body: { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("sortNo", .integer).notNull()//.unique() // UNIQUE constraint would make reordering Too Heckin Hard
                t.column("source1", .text).notNull()
                t.column("source2", .text)
            })
        }
    }
    
    func loadCharts() {
        do {
            try dbQueue.read { db in
                let charts = try Chart.fetchAll(db)
                self.charts = charts
            }
        } catch {
            logger.error("Could not load charts. \(error.localizedDescription, privacy: .public)")
        }
    }
    
    func saveCharts() {
        // make sure they're all in order
        var sortNo: Int64 = 0
        for i in 0..<charts.count {
            charts[i].sortNo = sortNo
            sortNo += 1
        }
        // update the database
        do {
            try dbQueue.write { db in
                // wipe them all out
                for chart in charts {
                    try chart.delete(db)
                }
                // and then put them back
                for i in 0..<charts.count {
                    try charts[i].insert(db)
                }
            }
        } catch {
            logger.error("Could not save charts. \(error.localizedDescription, privacy: .public)")
        }
    }
}
