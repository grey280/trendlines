//
//  trendlinesApp.swift
//  Shared
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI
import OSLog

@main
struct trendlinesApp: App {
    static let logger = Logger(subsystem: "net.twoeighty.trendlines", category: "Global")
    
    @StateObject var database = Database()! // listen we can't recover from this failing to launch
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(database)
        }
    }
}
