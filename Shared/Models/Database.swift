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
            try db.create(table: DataSet.databaseTableName, ifNotExists: true, body: { t in
                t.autoIncrementedPrimaryKey(DataSet.Columns.id.rawValue)
                t.column(DataSet.Columns.name.rawValue, .text).notNull()
            })
            
            try db.create(table: DataSetEntry.databaseTableName, ifNotExists: true, body: { (t) in
                t.autoIncrementedPrimaryKey(DataSetEntry.Columns.id.rawValue)
                t.column(DataSetEntry.Columns.dateAdded.rawValue, .date).notNull() // TODO: default via database?
                t.column(DataSetEntry.Columns.value.rawValue, .integer).notNull()
                t.column(DataSetEntry.Columns.datasetID.rawValue, .integer).notNull().references(DataSet.databaseTableName, column: DataSet.Columns.id.rawValue, onDelete: .cascade, onUpdate: .cascade)
            })
            
            try db.create(table: Chart.databaseTableName, ifNotExists: true, body: { t in
                t.autoIncrementedPrimaryKey(Chart.Columns.id.rawValue)
                t.column(Chart.Columns.sortNo.rawValue, .integer).notNull().unique()
                
                t.column(Chart.Columns.dataSource1Type.rawValue, .text).notNull()
                t.column(Chart.Columns.dataSource1DataSet.rawValue, .integer).references(DataSet.databaseTableName, column: DataSet.Columns.id.rawValue, onDelete: .cascade, onUpdate: .cascade)
                t.column(Chart.Columns.dataSource1Title.rawValue, .text).notNull()
                t.column(Chart.Columns.dataSource1Color.rawValue, .text).notNull()
                t.column(Chart.Columns.dataSource1ChartType.rawValue, .text).notNull()
                
                t.column(Chart.Columns.dataSource2Type.rawValue, .text)
                t.column(Chart.Columns.dataSource2DataSet.rawValue, .integer).references(DataSet.databaseTableName, column: DataSet.Columns.id.rawValue, onDelete: .cascade, onUpdate: .cascade)
                t.column(Chart.Columns.dataSource2Title.rawValue, .text)
                t.column(Chart.Columns.dataSource2Color.rawValue, .text)
                t.column(Chart.Columns.dataSource2ChartType.rawValue, .text)
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
