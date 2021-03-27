//
//  DataSourceType.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation

enum DataSourceType {
    case empty
    case entries(datasetID: DataSet.ID, mode: DataSourceDisplayMode)
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
