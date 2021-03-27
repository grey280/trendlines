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
        case dataSource1Type, dataSource1DataSet, dataSource1Title, dataSource1Color, dataSource1ChartType, dataSource1Mode
        case dataSource2Type, dataSource2DataSet, dataSource2Title, dataSource2Color, dataSource2ChartType, dataSource2Mode
    }
}

//extension Chart: Codable { }
extension Chart: MutablePersistableRecord {
    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.sortNo] = sortNo
        switch source1.sourceType {
        case .entries(let datasetID, let mode):
            container[Columns.dataSource1DataSet] = datasetID
            container[Columns.dataSource1Mode] = mode
        case .empty, .health:
            container[Columns.dataSource1DataSet] = nil
        }
        container[Columns.dataSource1Type] = source1.sourceType
        container[Columns.dataSource1Title] = source1.title
        container[Columns.dataSource1Color] = source1.color
        container[Columns.dataSource1ChartType] = source1.chartType
        
        if let source2 = source2 {
            switch source2.sourceType {
            case .entries(let datasetID, let mode):
                container[Columns.dataSource2DataSet] = datasetID
                container[Columns.dataSource2Mode] = mode
            case .empty, .health:
                container[Columns.dataSource2DataSet] = nil
            }
            container[Columns.dataSource2Type] = source2.sourceType
            container[Columns.dataSource2Title] = source2.title
            container[Columns.dataSource2Color] = source2.color
            container[Columns.dataSource2ChartType] = source2.chartType
        } else {
            container[Columns.dataSource2Type] = nil
            container[Columns.dataSource2DataSet] = nil
            container[Columns.dataSource2Title] = nil
            container[Columns.dataSource2Color] = nil
            container[Columns.dataSource2ChartType] = nil
        }
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
extension Chart: FetchableRecord {
    init(row: Row) {
        id = row[Columns.id]
        sortNo = row[Columns.sortNo]
        // unpack dataSource1
        let source1Reference: DataSet.ID? = row[Columns.dataSource1DataSet]
        let source1Mode: DataSourceDisplayMode? = row[Columns.dataSource1Mode]
        var source1Type: DataSourceType = row[Columns.dataSource1Type]
        if let s1r = source1Reference, let s1m = source1Mode {
            source1Type = .entries(datasetID: s1r, mode: s1m) // because the source1Reference has a FK, we know from the db that it's present
        }
        let source1Title: String = row[Columns.dataSource1Title]
        let source1Color: Color = row[Columns.dataSource1Color]
        let source1Chart: ChartType = row[Columns.dataSource1ChartType]
        source1 = DataSource(sourceType: source1Type, title: source1Title, color: source1Color, chartType: source1Chart)
        // unpack dataSource2
        let source2Reference: DataSet.ID? = row[Columns.dataSource2DataSet]
        let _source2Type: DataSourceType? = row[Columns.dataSource2Type]
        if var source2Type = _source2Type {
            let source2Title: String = row[Columns.dataSource2Title]
            let source2Color: Color = row[Columns.dataSource2Color]
            let source2Chart: ChartType = row[Columns.dataSource2ChartType]
            let source2Mode: DataSourceDisplayMode? = row[Columns.dataSource2Mode]
            if let s2r = source2Reference, let s2m = source2Mode {
                source2Type = .entries(datasetID: s2r, mode: s2m)
            }
            source2 = DataSource(sourceType: source2Type, title: source2Title, color: source2Color, chartType: source2Chart)
        }
    }
}
extension Chart: TableRecord { }
extension Chart: Identifiable { }

extension Color: DatabaseValueConvertible {
    public var databaseValue: DatabaseValue { "".databaseValue }
    
    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> Color? {
        guard let str = String.fromDatabaseValue(dbValue), let data = str.data(using: .utf8) else {
            return nil
        }
        
        return try? Database.jsonConverter.decode(Color.self, from: data)
    }
}
