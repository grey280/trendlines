//
//  XPoint.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import Foundation

protocol XPoint: Hashable, Comparable {
    var displayName: String { get }
    
    init?(date: Date)
}
extension Int: XPoint {
    var displayName: String { "\(self)" }
    
    init?(date: Date) {
        return nil
    }
}

extension Date: XPoint {
    var displayName: String { "\(self)" } // TODO: Better date display
    init?(date: Date) {
        self = date
    }
}
