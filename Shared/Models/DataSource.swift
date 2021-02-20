//
//  DataSource.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI
import GRDB

struct DataSource {
    typealias ID = Int64
    var id: ID?
    
    var sourceType: DataSourceType
    var title: String?
    var color: Color
    var chartType: ChartType?
}

extension DataSource: MutablePersistableRecord {
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        let JSONencoder = JSONEncoder()
        if let encoded = try? JSONencoder.encode(sourceType) {
            container["sourceType"] = encoded
        }
        container["title"] = title
        if let encColor = try? JSONencoder.encode(color) {
            container["color"] = encColor
        }
        if let chartType = chartType, let encType = try? JSONencoder.encode(chartType) {
            container["chartType"] = encType
        }
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
