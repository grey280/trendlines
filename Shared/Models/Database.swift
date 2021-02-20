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
    let logger: Logger
    let dbQueue: DatabaseQueue
    
    init?() {
        logger = Logger(subsystem: "net.twoeighty.trendlines", category: "Database")
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            logger.error("Could not get document directory URL")
            return nil
        }
        do {
            dbQueue = try DatabaseQueue(path: url.absoluteString)
        } catch {
            logger.error("Could not create database: \(error.localizedDescription, privacy: .public)")
            return nil
        }
        do {
            try initializeDatabase()
        } catch {
            logger.error("Could not confiugre database: \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
    
    private func initializeDatabase() throws {
        try dbQueue.write { db in
            try db.create(table: "charts", ifNotExists: true, body: { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("sortNo", .integer).notNull().unique()
                t.column("source1", .text).notNull()
                t.column("source2", .text)
            })
        }
    }
}
