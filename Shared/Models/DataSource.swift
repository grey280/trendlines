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

extension DataSource {
    var effectiveChartType: ChartType {
        switch sourceType {
        case .entries:
            return chartType ?? .bar
        case .health(let healthSubtype):
            switch healthSubtype {
            case .activity:
                return .bar
            case .nutrition:
                return .bar
            case .body(let bodySubtype):
                switch bodySubtype {
                case .restingHeartRate, .heartRateVariability, .bodyWeight, .leanBodyMass, .bodyFatPercentage:
                    return .line
                case .heartRate, .bloodPressure:
                    return .floatingBar
                }
            }
        }
    }
}
