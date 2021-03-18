//
//  DataSourceType.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation
import GRDB

enum DataSourceType {
    case empty
    case entries(datasetID: DataSet.ID)
    case health(HealthSource)
    
    enum HealthSource {
        case body(BodySource)
        enum BodySource: String, Codable, Hashable {
            case /*bloodPressure, */ bodyFatPercentage, bodyWeight, heartRate, heartRateVariability, leanBodyMass, restingHeartRate
        }
        
        case nutrition(NutritionSource)
        enum NutritionSource {
            case /* macronutrients, */ caffeine, calories, carbohydrates, fat, protein, sugar, water
            case vitamin(VitaminSource)
            enum VitaminSource: String, Codable, Hashable {
                case biotin, folate, niacin, pantothenicAcid, riboflavin, thiamin, vitaminA, vitaminB12, vitaminB6, vitaminC, vitaminD, vitaminE, vitaminK
            }
            
            case mineral(MineralSource)
            enum MineralSource: String, Codable, Hashable {
                case calcium, chloride, iron, magnesium, phosphorus, potassium, sodium, zinc
            }
            
            case micronutrient(MicronutrientSource)
            enum MicronutrientSource: String, Codable, Hashable {
                case chromium, copper, iodine, manganese, molybdenum, selenium
            }
        }
        
        case activity(ActivitySource)
        enum ActivitySource: String, Codable, Hashable {
            case /* mindfulMinutes, sleep, */ activeEnergy, cyclingDistance, flightsClimbed, standHours, steps, swimDistance, walkRunDistance, workoutTime
        }
    }
}

extension DataSourceType.HealthSource.NutritionSource: Hashable {}
extension DataSourceType.HealthSource: Hashable { }
extension DataSourceType: Hashable { }

extension DataSourceType: Codable {
    fileprivate enum CodingKeys: String, CodingKey {
        case primary, secondary, tertiary, quaternary
    }
    
    fileprivate enum Primary: String, Codable {
        case entries, health, empty
    }
    fileprivate enum HealthTypes: String, Codable {
        case body, nutrition, activity
        
        fileprivate enum NutritionTypes: String, Codable {
            case /* macronutrients, */ calories, carbohydrates, fat, protein, water, caffeine, sugar
            case vitamin, mineral, micronutrient
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let primary = try container.decode(Primary.self, forKey: .primary)
        switch primary {
        case .empty:
            self = .empty
        case .entries:
            let secondary = try container.decode(DataSet.ID.self, forKey: .secondary)
            self = .entries(datasetID: secondary)
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
                //                case .macronutrients:
                //                    self = .health(.nutrition(.macronutrients))
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
        case .empty:
            try container.encode(Primary.empty, forKey: .primary)
        case .entries(let datasetID):
            try container.encode(Primary.entries, forKey: .primary)
            try container.encode(datasetID, forKey: .secondary)
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
                //                case .macronutrients:
                //                    try container.encode(HealthTypes.NutritionTypes.macronutrients, forKey: .tertiary)
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

extension DataSourceType {
    var title: String {
        switch self {
        case .empty:
            return "Empty"
        case .entries:
            return "Data Set"
        case .health(let healthSource):
            switch healthSource {
            case .activity(let activity):
                switch activity {
                case .activeEnergy:
                    return "Calories Burned"
                case .cyclingDistance:
                    return "Cycling Distance"
                case .flightsClimbed:
                    return "Flights Climbed"
                case .standHours:
                    return "Stand Hours"
                case .steps:
                    return "Steps"
                case .swimDistance:
                    return "Swim Distance"
                case .walkRunDistance:
                    return "Walk/Run Distance"
                case .workoutTime:
                    return "Workout Time"
                }
            case .body(let body):
                switch body {
                case .bodyFatPercentage:
                    return "Body Fat Percentage"
                case .bodyWeight:
                    return "Body Mass"
                case .heartRate:
                    return "Heart Rate"
                case .heartRateVariability:
                    return "Heart Rate Variability"
                case .leanBodyMass:
                    return "Lean Body Mass"
                case .restingHeartRate:
                    return "Resting Heart Rate"
                }
            case .nutrition(let nutrition):
                switch nutrition {
                case .micronutrient(let micro):
                    switch micro {
                    case .chromium:
                        return "Chromium"
                    case .copper:
                        return "Copper"
                    case .iodine:
                        return "Iodine"
                    case .manganese:
                        return "Manganese"
                    case .molybdenum:
                        return "Molybdenum"
                    case .selenium:
                        return "Selenium"
                    }
                case .mineral(let mineral):
                    switch mineral {
                    case .calcium:
                        return "Calcium"
                    case .chloride:
                        return "Chloride"
                    case .iron:
                        return "Iron"
                    case .magnesium:
                        return "Magnesium"
                    case .phosphorus:
                        return "Phosphorus"
                    case .potassium:
                        return "Potassium"
                    case .sodium:
                        return "Sodium"
                    case .zinc:
                        return "Zinc"
                    }
                case .vitamin(let vitamin):
                    switch vitamin {
                    case .vitaminA:
                        return "Vitamin A"
                    case .thiamin:
                        return "Thiamin"
                    case .biotin:
                        return "Biotin"
                    case .folate:
                        return "Folate"
                    case .niacin:
                        return "Niacin"
                    case .pantothenicAcid:
                        return "Pantothenic Acid"
                    case .riboflavin:
                        return "Riboflavin"
                    case .vitaminB12:
                        return "Vitamin B12"
                    case .vitaminB6:
                        return "Vitamin B6"
                    case .vitaminC:
                        return "Vitamin C"
                    case .vitaminD:
                        return "Vitamin D"
                    case .vitaminE:
                        return "Vitamin E"
                    case .vitaminK:
                        return "Vitamin K"
                    }
                case .calories:
                    return "Calories"
                case .carbohydrates:
                    return "Carbohydrates"
                case .fat:
                    return "Fat"
                case .protein:
                    return "Protein"
                case .water:
                    return "Water"
                case .caffeine:
                    return "Caffeine"
                case .sugar:
                    return "Sugar"
                }
            }
        }
    }
}

extension DataSourceType.HealthSource.BodySource: CaseIterable {}
extension DataSourceType.HealthSource.ActivitySource: CaseIterable {}
extension DataSourceType.HealthSource.NutritionSource.VitaminSource: CaseIterable {}
extension DataSourceType.HealthSource.NutritionSource.MineralSource: CaseIterable {}
extension DataSourceType.HealthSource.NutritionSource.MicronutrientSource: CaseIterable {}

extension DataSourceType: DatabaseValueConvertible {
    var databaseValue: DatabaseValue { "".databaseValue }
    
    static func fromDatabaseValue(_ dbValue: DatabaseValue) -> DataSourceType? {
        guard let str = String.fromDatabaseValue(dbValue), let data = str.data(using: .utf8) else {
            return nil
        }
        
        return try? Database.jsonConverter.decode(DataSourceType.self, from: data)
    }
}
