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
            try db.create(table: Chart.databaseTableName, ifNotExists: true, body: { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("sortNo", .integer).notNull().unique()
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
    
    func save(chart: Chart) throws -> Chart {
        var chart = chart
        try dbQueue.write { db in
            try chart.save(db)
        }
        return chart
    }
    
    func remove(chart: Chart) throws -> Bool {
        return try dbQueue.write { db in
            try chart.delete(db)
        }
    }
}
