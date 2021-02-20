//
//  LineChartView.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import SwiftUI

struct LineChart<X: XPoint>: Shape {
    public init(data: [LineChartView<X>.DataPoint], yRange: (min: Double, max: Double), circleRadius: CGFloat = 1) {
        self.data = data
        self.yRange = yRange
        self.circleRadius = circleRadius
    }
    
    let data: [LineChartView<X>.DataPoint]
    let yRange: (min: Double, max: Double)
    let circleRadius: CGFloat
    
    // step size to go from an x point to the next x point
    func xStep(in width: CGFloat) -> CGFloat {
        // need to have one step for each data point (technically we'll have .5 leading and .5 trailing, but that adds up to 1!)
        // leave space for a radius-1 circle at each location
        (width / CGFloat(data.count))// - (CGFloat(2 * data.count) * circleRadius)
    }
    
    // y coordinates for the given point
    func yLocation(in rect: CGRect, dataPoint: LineChartView<X>.DataPoint) -> CGFloat {
        // rect.minY:yRange.min::rect.maxY:yRange.max :: dataPoint.y:result
        let percentile = (dataPoint.y - yRange.min) / (yRange.max - yRange.min)
        let delta = rect.maxY - rect.minY
        return CGFloat(percentile) * delta
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = data.first, let last = data.last else {
            return path
        }
        path.move(to: CGPoint(x: rect.minX, y: yLocation(in: rect, dataPoint: first)))
        let step = xStep(in: rect.width)
        
        var mapping: [CGPoint] = []
        for idx in 0..<data.count {
            let xVal = rect.minX + (step / 2) + (step * CGFloat(idx))
            let yVal = yLocation(in: rect, dataPoint: data[idx])
            mapping.append(CGPoint(x: xVal, y: yVal))
        }
        
        let algo = CubicCurveAlgorithm()
        let controlPts = algo.controlPointsFromPoints(dataPoints: mapping)
        
        for i in 0..<mapping.count {
            let point = mapping[i];
            
            if i==0 {
                path.addLine(to: point)
            } else {
                let segment = controlPts[i-1]
                path.addCurve(to: point, control1: segment.controlPoint1, control2: segment.controlPoint2)
            }
        }
        let finalPoint = CGPoint(x: rect.maxX, y: yLocation(in: rect, dataPoint: last))
        path.addLine(to: finalPoint)
        
        return path
    }
}

struct LineChartView<X: XPoint>: View {
    struct DataPoint {
        let x: X
        let y: Double
    }
    
    public init(
        data: [DataPoint],
        unit: String,
        color: Color = .gray,
        axisAlignment: YAxisView.AxisAlignment = .leading,
        hasOverlay: Bool = false,
        yRange: (min: Double, max: Double)? = nil
    ) {
        self.data = data.sorted(by: { (a, b) -> Bool in
            a.x < b.x
        })
        self.unit = unit
        self.color = color
        self.axisAlignment = axisAlignment
        if let overrideY = yRange {
            self.yRange = overrideY
        } else {
            let ySorted = data.map { $0.y }.sorted()
            self.yRange = (ySorted.first ?? 0.0, ySorted.last ?? 0.0)
        }
        self.hasOverlay = hasOverlay
    }
    
    let data: [DataPoint]
    let color: Color
    let unit: String
    let axisAlignment: YAxisView.AxisAlignment
    let hasOverlay: Bool
    
    private let yRange: (min: Double, max: Double)
    
    var spacing: CGFloat {
        switch data.count {
        case 0..<10:
            return 8
        case 10..<20:
            return 6
        default:
            return 4
        }
    }
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .bottom, spacing: spacing) {
                if axisAlignment == .leading {
                    YAxisView(min: "0", max: .init(format: "%.0f", yRange.max), unit: unit, color: color)
                } else if hasOverlay {
                    Spacer().frame(width: YAxisView.width)
                }
                LineChart<X>(data: data, yRange: yRange, circleRadius: 5).stroke(color)
                if axisAlignment == .trailing {
                    YAxisView(min: "0", max: .init(format: "%.0f", yRange.max), unit: unit, color: color)
                } else if hasOverlay {
                    Spacer().frame(width: YAxisView.width)
                }
            }
        }
    }
}

//
//  CubicCurveAlgorithm.swift
//  Bezier
//
//  Created by Ramsundar Shandilya on 10/12/15.
//  Copyright © 2015 Y Media Labs. All rights reserved.
// Source: https://github.com/Ramshandilya/Bezier/blob/master/Bezier/CubicCurveAlgorithm.swift
//

struct CubicCurveSegment
{
    let controlPoint1: CGPoint
    let controlPoint2: CGPoint
}

class CubicCurveAlgorithm
{
    private var firstControlPoints: [CGPoint?] = []
    private var secondControlPoints: [CGPoint?] = []
    
    func controlPointsFromPoints(dataPoints: [CGPoint]) -> [CubicCurveSegment] {
        
        //Number of Segments
        let count = dataPoints.count - 1
        
        //P0, P1, P2, P3 are the points for each segment, where P0 & P3 are the knots and P1, P2 are the control points.
        if count == 1 {
            let P0 = dataPoints[0]
            let P3 = dataPoints[1]
            
            //Calculate First Control Point
            //3P1 = 2P0 + P3
            
            let P1x = (2*P0.x + P3.x)/3
            let P1y = (2*P0.y + P3.y)/3
            
            firstControlPoints.append(CGPoint(x: P1x, y: P1y))
            
            //Calculate second Control Point
            //P2 = 2P1 - P0
            let P2x = (2*P1x - P0.x)
            let P2y = (2*P1y - P0.y)
            
            secondControlPoints.append(CGPoint(x: P2x, y: P2y))
        } else {
            firstControlPoints = Array(repeating: nil, count: count)

            var rhsArray = [CGPoint]()
            
            //Array of Coefficients
            var a = [CGFloat]()
            var b = [CGFloat]()
            var c = [CGFloat]()
            
            for i in 0..<count {
                var rhsValueX: CGFloat = 0
                var rhsValueY: CGFloat = 0
                
                let P0 = dataPoints[i];
                let P3 = dataPoints[i+1];
                
                if i==0 {
                    a.append(0)
                    b.append(2)
                    c.append(1)
                    
                    //rhs for first segment
                    rhsValueX = P0.x + 2*P3.x;
                    rhsValueY = P0.y + 2*P3.y;
                    
                } else if i == count-1 {
                    a.append(2)
                    b.append(7)
                    c.append(0)
                    
                    //rhs for last segment
                    rhsValueX = 8*P0.x + P3.x;
                    rhsValueY = 8*P0.y + P3.y;
                } else {
                    a.append(1)
                    b.append(4)
                    c.append(1)
                    
                    rhsValueX = 4*P0.x + 2*P3.x;
                    rhsValueY = 4*P0.y + 2*P3.y;
                }
                
                rhsArray.append(CGPoint(x: rhsValueX, y: rhsValueY))
            }
            
            //Solve Ax=B. Use Tridiagonal matrix algorithm a.k.a Thomas Algorithm
            for i in 1..<count {
                let rhsValueX = rhsArray[i].x
                let rhsValueY = rhsArray[i].y
                
                let prevRhsValueX = rhsArray[i-1].x
                let prevRhsValueY = rhsArray[i-1].y
                
                let m = CGFloat(a[i]/b[i-1])
                
                let b1 = b[i] - m * c[i-1];
                b[i] = b1
                
                let r2x = rhsValueX - m * prevRhsValueX
                let r2y = rhsValueY - m * prevRhsValueY
                
                rhsArray[i] = CGPoint(x: r2x, y: r2y)
            }
            //Get First Control Points
            
            //Last control Point
            let lastControlPointX = rhsArray[count-1].x/b[count-1]
            let lastControlPointY = rhsArray[count-1].y/b[count-1]
            
            firstControlPoints[count-1] = CGPoint(x: lastControlPointX, y: lastControlPointY)
            
            for i in (0 ..< count - 1).reversed() {
                if let nextControlPoint = firstControlPoints[i+1] {
                    let controlPointX = (rhsArray[i].x - c[i] * nextControlPoint.x)/b[i]
                    let controlPointY = (rhsArray[i].y - c[i] * nextControlPoint.y)/b[i]
                    
                    firstControlPoints[i] = CGPoint(x: controlPointX, y: controlPointY)
                }
            }
            
            //Compute second Control Points from first
            
            for i in 0..<count {
                
                if i == count-1 {
                    let P3 = dataPoints[i+1]
                    
                    guard let P1 = firstControlPoints[i] else{
                        continue
                    }
                    
                    let controlPointX = (P3.x + P1.x)/2
                    let controlPointY = (P3.y + P1.y)/2
                    
                    secondControlPoints.append(CGPoint(x: controlPointX, y: controlPointY))
                    
                } else {
                    let P3 = dataPoints[i+1]
                    
                    guard let nextP1 = firstControlPoints[i+1] else {
                        continue
                    }
                    
                    let controlPointX = 2*P3.x - nextP1.x
                    let controlPointY = 2*P3.y - nextP1.y
                    
                    secondControlPoints.append(CGPoint(x: controlPointX, y: controlPointY))
                }
            }
        }
        
        var controlPoints = [CubicCurveSegment]()
        
        for i in 0..<count {
            if let firstControlPoint = firstControlPoints[i],
                let secondControlPoint = secondControlPoints[i] {
                let segment = CubicCurveSegment(controlPoint1: firstControlPoint, controlPoint2: secondControlPoint)
                controlPoints.append(segment)
            }
        }
        
        return controlPoints
    }
}

struct LineChartView_Previews: PreviewProvider {
    static let testData: [LineChartView<Int>.DataPoint] = [
        .init(x: 1, y: 3),
        .init(x: 2, y: 2),
        .init(x: 3, y: 3)
    ]
    
    static var previews: some View {
        Group {
            LineChartView<Int>(data: testData, unit: "Number", axisAlignment: .trailing).padding()
            LineChartView<Int>(data: (0...30).map { LineChartView<Int>.DataPoint(x: $0, y: Double($0) )}, unit: "Things").padding()
        }
    }
}
