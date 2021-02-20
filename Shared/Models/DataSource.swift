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
    
    var unitName: String {
        switch sourceType {
        case .entries:
            return "count"
        case .health(let healthSubtype):
            switch healthSubtype {
            case .activity(let activityType):
                switch activityType {
                case .activeEnergy:
                    return "Calories" // TODO: Replace with unit lookup
                case .cyclingDistance, .walkRunDistance:
                    return "miles" // TODO: Replace with unit lookup
                case .flightsClimbed:
                    return "flights"
                case .mindfulMinutes, .workoutTime:
                    return "minutes"
                case .sleep, .standHours:
                    return "hours"
                case .steps:
                    return "steps"
                case .swimDistance:
                    return "yards" // TODO: Replace with unit lookup
                }
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
