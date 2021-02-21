//
//  DataProvider.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation
import Combine

protocol DataProviderPoint {
    associatedtype X: XPoint
    var x: X { get }
    var y: Double { get }
}

extension DataProviderPoint {
    var lineChart: LineChartView<X>.DataPoint {
        get {
            .init(x: x, y: y)
        }
        
    }
    var barChart: BarChartView<X>.DataPoint {
        get {
            .init(x: x, y: y)
        }
    }
}

protocol DataProvider: ObservableObject {
    associatedtype X: XPoint
    associatedtype Point: DataProviderPoint
    
    var points: [Point] { get }
}

protocol RangedDataProvider: ObservableObject {
    associatedtype X: XPoint
    
    var data: [RangedBarChartView<X>.DataPoint] { get }
}
