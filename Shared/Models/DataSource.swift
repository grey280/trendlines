//
//  DataSource.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import SwiftUI

struct DataSource {
    var sourceType: DataSourceType
    var title: String
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
                case .heartRate:// , .bloodPressure:
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
                case .workoutTime: // .mindfulMinutes,
                    return "minutes"
                case .standHours: // sleep, 
                    return "hours"
                case .steps:
                    return "steps"
                case .swimDistance:
                    return "yards" // TODO: Replace with unit lookup
                }
            case .nutrition(let nutrition):
                switch nutrition {
                case .vitamin, .mineral, .carbohydrates, .fat, .protein, .sugar:
                    return "g" // TODO: Replace with unit lookup
                case .micronutrient:
                    return "mcg" // TODO: Replace with unit lookup
//                case .macronutrients:
//                    return "macros"
                case .calories:
                    return "Calories" // TODO: Replace with unit lookup
                case .caffeine:
                    return "mg" // TODO: Replace with unit lookup
                case .water:
                    return "L" // TODO: Replace with unit lookup
                }
            case .body(let bodySubtype):
                switch bodySubtype {
                case .restingHeartRate, .heartRate:
                    return "bpm"
//                case .bloodPressure:
//                    return "mmHg"
                case .bodyFatPercentage:
                    return "%"
                case .bodyWeight, .leanBodyMass:
                    return "lbs" // TODO: Replace with unit lookup
                case .heartRateVariability:
                    return "ms"
                }
            }
        }
    }
}
