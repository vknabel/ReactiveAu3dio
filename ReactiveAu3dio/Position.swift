//
//  Position.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 26.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public struct Position {
    /// Max 1.0 and min -1.0
    public var x: Double
    public var y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

private func minabs(_ lhs: Double, _ rhs: Double) -> Double {
    if abs(lhs) <= abs(rhs) {
        return lhs
    } else {
        return rhs
    }
}

private func direction(_ left: Double, _ right: Double) -> Double {
    let diff = minabs(
        (left - right).remainder(dividingBy: 1.0),
        (left - (right + 0.5).remainder(dividingBy: 1.0)).remainder(dividingBy: 1.0))

    return diff * -4
}

public extension Position {
    public func horizontalDirection(to: Position) -> Double {
        return direction(x, to.x)
    }

    public func verticalDirection(to: Position) -> Double {
        return direction(x, to.x)
    }
}
