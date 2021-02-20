//
//  trendlinesApp.swift
//  Shared
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

@main
struct trendlinesApp: App {
    @StateObject var database = Database()! // listen we can't recover from this failing to launch
    
    var body: some Scene {
        WindowGroup {
            ContentView(r: false).environmentObject(database)
        }
    }
}
