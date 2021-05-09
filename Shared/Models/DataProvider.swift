//
//  DataProvider.swift
//  trendlines
//
//  Created by Grey Patterson on 2/20/21.
//

import Foundation
import Combine

#if !os(macOS)
import HealthKit
#endif

struct DatePoint {
    let x: Date
    let _y: Double
    var y: Double {
        if let min = yMin, let max = yMax {
            return (min + max) / 2
        }
        return _y
    }
    let yMin: Double?
    let yMax: Double?
    
    public init(_ x: Date, y: Double) {
        self.x = x
        self._y = y
        self.yMax = nil
        self.yMin = nil
    }
    public init(_ x:Date, yMin: Double, yMax: Double) {
        self.x = x
        self.yMin = yMin
        self.yMax = yMax
        self._y = (yMin + yMax) / 2
    }
}

class DataProvider: ObservableObject {
    @Published var points: [DatePoint] = []
}

class NoopDataProvider: DataProvider {
    override var points: [DatePoint] {
        get {
            [.init(Date(), y: 0.0)]
        }
        set {
            // do nothing
        }
    }
}

class DemoDataProvider: DataProvider {
    private let _points: [DatePoint] = {
        var pointBuilder: [DatePoint] = []
        var workingDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        for i in -2..<3 {
            let low: Double = Double(i) - (Double(i)/2)
            let high: Double = Double(i) + (Double(i)/2)
            pointBuilder.append(.init(workingDate, yMin: low, yMax: high))
            workingDate = Calendar.current.date(byAdding: .day, value: 1, to: workingDate)!
        }
        return pointBuilder
    }()

    override var points: [DatePoint] {
        get {
            _points
        }
        set {
            // do nothing
        }
    }
}
