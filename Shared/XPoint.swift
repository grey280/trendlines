//
//  XPoint.swift
//  trendlines
//
//  Created by Grey Patterson on 2/19/21.
//

import Foundation

protocol XPoint: Hashable, Comparable {
    var displayName: String { get }
}
extension Int: XPoint {
    var displayName: String { "\(self)" }
}
