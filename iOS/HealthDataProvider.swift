//
//  HealthDataProvider.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation
import HealthKit

fileprivate class HealthHelper {
    static let healthStore = HKHealthStore()
}

class HealthDataProvider<X: XPoint>: DataProvider {
    @Published public private(set) var points: [HealthPoint] = []
    struct HealthPoint: DataProviderPoint {
        let x: X
        let y: Double
    }
    
    typealias Point = HealthPoint
    
    let dataType: DataSourceType.HealthSource
    
    init(_ type: DataSourceType.HealthSource) {
        self.dataType = type
        
    }
}
