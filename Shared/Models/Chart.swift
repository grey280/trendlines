//
//  Chart.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI
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
        #warning("Replace with DataSet.ID type reference")
        let source1Reference: Int64? = row[Columns.dataSource1DataSet]
        var source1Type: DataSourceType = row[Columns.dataSource1Type]
        if let s1r = source1Reference {
            source1Type = .entries(datasetID: s1r) // because the source1Reference has a FK, we know from the db that it's present
        }
        let source1Title: String = row[Columns.dataSource1Title]
        let source1Color: Color = row[Columns.dataSource1Color]
        let source1Chart: ChartType = row[Columns.dataSource1ChartType]
        source1 = DataSource(sourceType: source1Type, title: source1Title, color: source1Color, chartType: source1Chart)
        // unpack dataSource2
        #warning("Replace with DataSet.ID type reference")
        let source2Reference: Int64? = row[Columns.dataSource2DataSet]
        let _source2Type: DataSourceType? = row[Columns.dataSource2Type]
        if var source2Type = _source2Type {
            let source2Title: String = row[Columns.dataSource2Title]
            let source2Color: Color = row[Columns.dataSource2Color]
            let source2Chart: ChartType = row[Columns.dataSource2ChartType]
            if let s2r = source2Reference {
                source2Type = .entries(datasetID: s2r)
            }
            source2 = DataSource(sourceType: source2Type, title: source2Title, color: source2Color, chartType: source2Chart)
        }
    }
}
extension Chart: TableRecord { }
extension Chart: Identifiable { }

extension Color: DatabaseValueConvertible {}
