//
//  HealthDataProvider.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation
import HealthKit
import OSLog

fileprivate class HealthHelper {
    static let healthStore = HKHealthStore()
    static let logger = Logger(subsystem: "net.twoeighty.trendlines", category: "Health")
}

class HealthDataProvider<X: XPoint>: DataProvider {
    @Published public private(set) var points: [HealthPoint] = []
    struct HealthPoint: DataProviderPoint {
        let x: X
        let y: Double
    }
    
    typealias Point = HealthPoint
    
    let dataType: DataSourceType.HealthSource
    
    init?(_ type: DataSourceType.HealthSource) {
        self.dataType = type
        guard HKHealthStore.isHealthDataAvailable() else {
            return nil
        }
        if HealthHelper.healthStore.authorizationStatus(for: objectType) == .notDetermined {
            let readType: Set<HKObjectType> = [objectType]
            HealthHelper.healthStore.requestAuthorization(toShare: nil, read: readType) { (success, error) in
                if let err = error {
                    HealthHelper.logger.error("Error while requesting authorization: \(err.localizedDescription, privacy: .public)")
                }
            }
        } else {
            loadData()
        }
    }
    
    func loadData() {
        guard let monthAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) else {
            HealthHelper.logger.error("Could not create '30 days ago' date.")
            return
        }
        guard let halfTime = Calendar.current.date(byAdding: .day, value: -15, to: Date()) else {
            HealthHelper.logger.error("Could not create '15 days ago' date.")
            return
        }
        let startDate = Calendar.current.startOfDay(for: monthAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: objectType, quantitySamplePredicate: predicate, options: queryOptions, anchorDate: Calendar.current.startOfDay(for: halfTime), intervalComponents: interval)
        
    private var querySum: Bool {
        switch self.dataType {
        case .activity, .nutrition:
            return true
        case .body:
            return false
        }
    }
    
    private var queryOptions: HKStatisticsOptions {
        switch self.dataType {
        case .body(let body):
            switch body {
            case .bodyFatPercentage, .bodyWeight, .heartRate, .heartRateVariability, .leanBodyMass, .restingHeartRate:
                return .discreteAverage
            }
        case .activity(let activity):
            switch activity {
            case .activeEnergy, .cyclingDistance, .flightsClimbed, .standHours, .steps, .swimDistance, .walkRunDistance, .workoutTime:
                return .cumulativeSum
            }
        case .nutrition(_):
            return .cumulativeSum
        }
    }
    
    private var objectType: HKQuantityType {
        switch self.dataType {
        case .body(let body):
            switch body {
            case .bodyFatPercentage:
                return HKQuantityType.quantityType(forIdentifier: .bodyFatPercentage)!
            case .bodyWeight:
                return HKQuantityType.quantityType(forIdentifier: .bodyMass)!
            case .heartRate:
                return HKQuantityType.quantityType(forIdentifier: .heartRate)!
            case .heartRateVariability:
                return HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
            case .leanBodyMass:
                return HKQuantityType.quantityType(forIdentifier: .leanBodyMass)!
            case .restingHeartRate:
                return HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
            }
        case .activity(let activity):
            switch activity {
            case .activeEnergy:
                return HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            case .cyclingDistance:
                return HKQuantityType.quantityType(forIdentifier: .distanceCycling)!
            case .flightsClimbed:
                return HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
//            case .mindfulMinutes:
//                return HKObjectType.categoryType(forIdentifier: .mindfulSession)!
//            case .sleep:
//                return HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
            case .standHours:
                return HKQuantityType.quantityType(forIdentifier: .appleStandTime)!
            case .steps:
                return HKQuantityType.quantityType(forIdentifier: .stepCount)!
            case .swimDistance:
                return HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!
            case .walkRunDistance:
                return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
            case .workoutTime:
                return HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
            }
        case .nutrition(let nutrition):
            switch nutrition {
            case .caffeine:
                return HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!
            case .calories:
                return HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
            case .carbohydrates:
                return HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates)!
            case .fat:
                return HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal)!
            case .protein:
                return HKQuantityType.quantityType(forIdentifier: .dietaryProtein)!
            case .sugar:
                return HKQuantityType.quantityType(forIdentifier: .dietarySugar)!
            case .water:
                return HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
            case .micronutrient(let micro):
                switch micro {
                case .chromium:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryChromium)!
                case .copper:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryCopper)!
                case .iodine:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryIodine)!
                case .manganese:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryManganese)!
                case .molybdenum:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryMolybdenum)!
                case .selenium:
                    return HKQuantityType.quantityType(forIdentifier: .dietarySelenium)!
                }
            case .mineral(let mineral):
                switch mineral {
                case .calcium:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryCalcium)!
                case .chloride:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryChloride)!
                case .iron:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryIron)!
                case .magnesium:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryMagnesium)!
                case .phosophorus:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryPhosphorus)!
                case .potassium:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryPotassium)!
                case .sodium:
                    return HKQuantityType.quantityType(forIdentifier: .dietarySodium)!
                case .zinc:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryZinc)!
                }
            case .vitamin(let vitamin):
                switch vitamin {
                case .biotin:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryBiotin)!
                case .folate:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryFolate)!
                case .niacin:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryNiacin)!
                case .pantothenicAcid:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryPantothenicAcid)!
                case .riboflavin:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryRiboflavin)!
                case .thiamin:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryThiamin)!
                case .vitaminA:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryVitaminA)!
                case .vitaminB12:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryVitaminB12)!
                case .vitaminB6:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryVitaminB6)!
                case .vitaminC:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryVitaminC)!
                case .vitaminD:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryVitaminD)!
                case .vitaminE:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryVitaminE)!
                case .vitaminK:
                    return HKQuantityType.quantityType(forIdentifier: .dietaryVitaminK)!
                }
            }
        }
    }
}
