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
        enum BodySource: String, Codable {
            case restingHeartRate, heartRateVariability, heartRate, bloodPressure, bodyWeight, leanBodyMass, bodyFatPercentage
        }
        
        case nutrition(NutritionSource)
        enum NutritionSource {
            case macronutrients, calories, carbohydrates, fat, protein, water, caffeine, sugar
            case vitamin(VitaminSource)
            enum VitaminSource: String, Codable {
                case vitaminA, thiamin, riboflavin, niacin, pantothenicAcid, vitaminB6, biotin, vitaminB12, vitaminC, vitaminD, vitaminE, vitaminK, folate
            }
            
            case mineral(MineralSource)
            enum MineralSource: String, Codable {
                case calcium, chloride, iron, magnesium, phosophorus, potassium, sodium, zinc
            }
            
            case micronutrient(MicronutrientSource)
            enum MicronutrientSource: String, Codable {
                case chromium, copper, iodine, manganese, molybdenum, selenium
            }
        }
        
        case activity(ActivitySource)
        enum ActivitySource: String, Codable {
            case activeEnergy, walkRunDistance, swimDistance, cyclingDistance, flightsClimbed, steps, standHours, mindfulMinutes, sleep, workoutTime
        }
    }
}

extension DataSourceType: Codable {
    fileprivate enum CodingKeys: String, CodingKey {
        case primary, secondary, tertiary, quaternary
    }
    
    fileprivate enum Primary: String, Codable {
        case custom, health
    }
    fileprivate enum HealthTypes: String, Codable {
        case body, nutrition, activity
        
        fileprivate enum NutritionTypes: String, Codable {
            case macronutrients, calories, carbohydrates, fat, protein, water, caffeine, sugar
            case vitamin, mineral, micronutrient
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let primary = try container.decode(Primary.self, forKey: .primary)
        switch primary {
        case .custom:
            self = .custom
        case .health:
            let secondary = try container.decode(HealthTypes.self, forKey: .secondary)
            switch secondary {
            case .body:
                let tertiary = try container.decode(DataSourceType.HealthSource.BodySource.self, forKey: .tertiary)
                self = .health(.body(tertiary))
            case .activity:
                let tertiary = try container.decode(DataSourceType.HealthSource.ActivitySource.self, forKey: .tertiary)
                self = .health(.activity(tertiary))
            case .nutrition:
                let tertiary = try container.decode(HealthTypes.NutritionTypes.self, forKey: .tertiary)
                switch tertiary {
                case .macronutrients:
                    self = .health(.nutrition(.macronutrients))
                case .calories:
                    self = .health(.nutrition(.calories))
                case .carbohydrates:
                    self = .health(.nutrition(.carbohydrates))
                case .fat:
                    self = .health(.nutrition(.fat))
                case .protein:
                    self = .health(.nutrition(.protein))
                case .water:
                    self = .health(.nutrition(.water))
                case .caffeine:
                    self = .health(.nutrition(.caffeine))
                case .sugar:
                    self = .health(.nutrition(.sugar))
                case .vitamin:
                    let quaternary = try container.decode(DataSourceType.HealthSource.NutritionSource.VitaminSource.self, forKey: .quaternary)
                    self = .health(.nutrition(.vitamin(quaternary)))
                case .mineral:
                    let quaternary = try container.decode(DataSourceType.HealthSource.NutritionSource.MineralSource.self, forKey: .quaternary)
                    self = .health(.nutrition(.mineral(quaternary)))
                case .micronutrient:
                    let quaternary = try container.decode(DataSourceType.HealthSource.NutritionSource.MicronutrientSource.self, forKey: .quaternary)
                    self = .health(.nutrition(.micronutrient(quaternary)))
                }
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        <#code#>
    }
}
