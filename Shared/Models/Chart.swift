//
//  Chart.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation
import GRDB

struct Chart {
    typealias ID = Int64?
    var id: ID
    
    var sortNo: Int64
    var source1: DataSource
    var source2: DataSource?
    
    enum Columns: String, ColumnExpression {
        case id, sortNo
        case dataSource1Type, dataSource1DataSet, dataSource1Title, dataSource1Color, dataSource1ChartType
        case dataSource2Type, dataSource2DataSet, dataSource2Title, dataSource2Color, dataSource2ChartType
    }
}

//extension Chart: Codable { }
extension Chart: MutablePersistableRecord {
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
extension Chart: FetchableRecord {
    init(row: Row) {
        id = row[Columns.id]
        sortNo = row[Columns.sortNo]
        // unpack dataSource1
        
        // unpack dataSource2
        
    }
}
extension Chart: TableRecord { }
extension Chart: Identifiable { }
