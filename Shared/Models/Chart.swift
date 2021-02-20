//
//  Chart.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation

struct Chart {
    typealias ID = Int64
    var id: ID?
    
    var sortNo: Int64
    var source1: DataSource
    var source2: DataSource?
}
