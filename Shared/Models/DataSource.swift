//
//  DataSource.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI

struct DataSource {
    var sourceType: DataSourceType
    var title: String?
    var color: Color
    var chartType: ChartType?
}
extension DataSource: Codable { }
