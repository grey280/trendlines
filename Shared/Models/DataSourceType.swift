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
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .custom:
            try container.encode(Primary.custom, forKey: .primary)
        case .health(let healthSource):
            try container.encode(Primary.health, forKey: .primary)
            switch healthSource {
            case .activity(let activity):
                try container.encode(HealthTypes.activity, forKey: .secondary)
                try container.encode(activity, forKey: .tertiary)
            case .body(let body):
                try container.encode(HealthTypes.body, forKey: .secondary)
                try container.encode(body, forKey: .tertiary)
            case .nutrition(let nutrition):
                try container.encode(HealthTypes.nutrition, forKey: .secondary)
                switch nutrition {
                case .micronutrient(let micro):
                    try container.encode(HealthTypes.NutritionTypes.micronutrient, forKey: .tertiary)
                    try container.encode(micro, forKey: .quaternary)
                case .mineral(let mineral):
                    try container.encode(HealthTypes.NutritionTypes.mineral, forKey: .tertiary)
                    try container.encode(mineral, forKey: .quaternary)
                case .vitamin(let vitamin):
                    try container.encode(HealthTypes.NutritionTypes.vitamin, forKey: .tertiary)
                    try container.encode(vitamin, forKey: .quaternary)
                case .macronutrients:
                    try container.encode(HealthTypes.NutritionTypes.macronutrients, forKey: .tertiary)
                case .calories:
                    try container.encode(HealthTypes.NutritionTypes.calories, forKey: .tertiary)
                case .carbohydrates:
                    try container.encode(HealthTypes.NutritionTypes.carbohydrates, forKey: .tertiary)
                case .fat:
                    try container.encode(HealthTypes.NutritionTypes.fat, forKey: .tertiary)
                case .protein:
                    try container.encode(HealthTypes.NutritionTypes.protein, forKey: .tertiary)
                case .water:
                    try container.encode(HealthTypes.NutritionTypes.water, forKey: .tertiary)
                case .caffeine:
                    try container.encode(HealthTypes.NutritionTypes.caffeine, forKey: .tertiary)
                case .sugar:
                    try container.encode(HealthTypes.NutritionTypes.sugar, forKey: .tertiary)
                }
            }
        }
    }
}
