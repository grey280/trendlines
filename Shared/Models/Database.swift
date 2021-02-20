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
    }
}
