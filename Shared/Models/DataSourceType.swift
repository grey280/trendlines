//
//  DataSourceType.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation

enum DataSourceType {
    case custom
    case health(HealthSource)
    
    enum HealthSource {
        case body(BodySource)
        enum BodySource {
            case restingHeartRate, heartRateVariability, heartRate, bloodPressure, bodyWeight, leanBodyMass, bodyFatPercentage
        }
        
        case nutrition(NutritionSource)
        enum NutritionSource {
            case macronutrients, calories, carbohydrates, fat, protein, water, caffeine, sugar
            case vitamin(VitaminSource)
            enum VitaminSource {
                
            }
            
            case mineral(MineralSource)
            enum MineralSource {
                
            }
            
            case micronutrient(MicronutrientSource)
            enum MicronutrientSource {
                
            }
        }
        
        case activity(ActivitySource)
        enum ActivitySource {
            case activeEnergy, walkRunDistance, swimDistance, cyclingDistance, flightsClimbed, steps, standHours, mindfulMinutes, sleep, workoutTime
        }
    }
}
