//
//  DataSourceType+Codable.swift
//  trendlines
//
//  Created by Grey Patterson on 3/27/21.
//

import Foundation
import GRDB

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
            let tertiary = try container.decode(DataSourceDisplayMode.self, forKey: .tertiary)
            self = .entries(datasetID: secondary, mode: tertiary)
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
        case .entries(let datasetID, let mode):
            try container.encode(Primary.entries, forKey: .primary)
            try container.encode(datasetID, forKey: .secondary)
            try container.encode(mode, forKey: .tertiary)
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

extension DataSourceType: DatabaseValueConvertible {
    var databaseValue: DatabaseValue { "".databaseValue }
    
    static func fromDatabaseValue(_ dbValue: DatabaseValue) -> DataSourceType? {
        guard let str = String.fromDatabaseValue(dbValue), let data = str.data(using: .utf8) else {
            return nil
        }
        
        return try? Database.jsonConverter.decode(DataSourceType.self, from: data)
    }
}
