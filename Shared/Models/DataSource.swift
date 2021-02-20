//
//  DataSource.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI

struct DataSource {
    typealias ID = Int64
    var id: ID?
    
    var sourceType: DataSourceType
    var title: String?
    var color: Color
    var chartType: ChartType?
}
