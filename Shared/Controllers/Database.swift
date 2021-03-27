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
    static let jsonConverter = JSONDecoder()
    
    @Published var charts: [Chart] = []
    @Published var customDataSets: [DataSet] = []
    
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
        loadDatasets()
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
                t.column(Chart.Columns.dataSource1Mode.rawValue, .text)
                
                t.column(Chart.Columns.dataSource2Type.rawValue, .text)
                t.column(Chart.Columns.dataSource2DataSet.rawValue, .integer).references(DataSet.databaseTableName, column: DataSet.Columns.id.rawValue, onDelete: .cascade, onUpdate: .cascade)
                t.column(Chart.Columns.dataSource2Title.rawValue, .text)
                t.column(Chart.Columns.dataSource2Color.rawValue, .text)
                t.column(Chart.Columns.dataSource2ChartType.rawValue, .text)
                t.column(Chart.Columns.dataSource2Mode.rawValue, .text)
            })
        }
    }
    
    // MARK: Charts
    
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
    
    // MARK: Data sets
    func loadDatasets() {
        do {
            try dbQueue.read { db in
                let sets = try DataSet.fetchAll(db)
                self.customDataSets = sets
            }
        } catch {
            logger.error("Could not load datasets. \(error.localizedDescription, privacy: .public)")
        }
    }
    
    @discardableResult
    func add(dataSet: DataSet) -> DataSet? {
        do {
            var copySet = dataSet
            try dbQueue.write { db in
                try copySet.insert(db)
            }
            loadDatasets()
            return copySet
        } catch {
            logger.error("Could not save dataset. \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
    
    @discardableResult
    func delete(dataSet: DataSet) -> Bool {
        do {
            let couldDelete = try dbQueue.write { db in
                return try dataSet.delete(db)
            }
            if (couldDelete) {
                loadDatasets()
                return true
            }
            return false
        } catch {
            logger.error("Could not delete dataset. \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
    
    @discardableResult
    func delete(dataSets: [DataSet]) -> Bool {
        do {
            let couldDelete = try dbQueue.write { db in
                try DataSet.deleteAll(db, keys: dataSets.compactMap { $0.id })
            }
            loadDatasets()
            if (couldDelete == dataSets.count) {
                return true
            }
            logger.warning("Attempted to delete \(dataSets.count, privacy: .public) data sets, but could only delete \(couldDelete, privacy: .public)")
            return false
        } catch {
            logger.error("Could not delete datasets. \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
    
    // MARK: Data Set Entries
    func loadDataSetEntries(dataSet: DataSet) -> [DataSetEntry]? {
        do {
            return try dbQueue.read { db in
                try DataSetEntry
                    .filter(DataSetEntry.Columns.datasetID == dataSet.id)
                    .fetchAll(db)
            }
        } catch {
            logger.error("Could not load entries. \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
    
    func queryDataSetEntries(dataSet: DataSet, mode: DataSourceDisplayMode, startDate: Date) -> [DatePoint]? {
        do {
            return try dbQueue.read { db in
                let request: QueryInterfaceRequest<DataSetEntry>
                switch mode {
                case .average:
                    request = DataSetEntry
                        .filter(DataSetEntry.Columns.datasetID == dataSet.id)
                        .filter(DataSetEntry.Columns.dateAdded >= startDate)
                        .select(sql: "DATE(\(DataSetEntry.Columns.dateAdded.rawValue)), AVG(\(DataSetEntry.Columns.value.rawValue))")
                        .group(sql: "DATE(\(DataSetEntry.Columns.dateAdded.rawValue))")
                case .count:
                    request = DataSetEntry
                        .filter(DataSetEntry.Columns.datasetID == dataSet.id)
                        .filter(DataSetEntry.Columns.dateAdded >= startDate)
                        .select(sql: "DATE(\(DataSetEntry.Columns.dateAdded.rawValue)), COUNT(*)")
                        .group(sql: "DATE(\(DataSetEntry.Columns.dateAdded.rawValue))")
                case .sum:
                    request = DataSetEntry
                        .filter(DataSetEntry.Columns.datasetID == dataSet.id)
                        .filter(DataSetEntry.Columns.dateAdded >= startDate)
                        .select(sql: "DATE(\(DataSetEntry.Columns.dateAdded.rawValue)), SUM(\(DataSetEntry.Columns.value.rawValue))")
                        .group(sql: "DATE(\(DataSetEntry.Columns.dateAdded.rawValue))")
                }
                
            }
            
        } catch {
            logger.error("Could not query entries. \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
    
    @discardableResult
    func delete(entry: DataSetEntry) -> Bool {
        do {
            let couldAdd = try dbQueue.write { db in
                return try entry.delete(db)
            }
            if (couldAdd) {
                loadDatasets()
                return true
            }
            return false
        } catch {
            logger.error("Could not delete entry. \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
    @discardableResult
    func delete(entries: [DataSetEntry]) -> Bool {
        do {
            let couldDelete = try dbQueue.write { db in
                try DataSetEntry.deleteAll(db, keys: entries.compactMap { $0.id })
            }
            if (couldDelete == entries.count) {
                return true
            }
            logger.warning("Attempted to delete \(entries.count, privacy: .public) data entries, but could only delete \(couldDelete, privacy: .public)")
            return false
        } catch {
            logger.error("Could not delete entries. \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
    
    @discardableResult
    func add(entry: DataSetEntry) -> Bool {
        do {
            var copy = entry
            try dbQueue.write { db in
                try copy.insert(db)
            }
            return true
        } catch {
            logger.error("Could not save entry. \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
}
