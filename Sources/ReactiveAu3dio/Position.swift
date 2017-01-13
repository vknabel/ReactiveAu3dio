//
//  Position.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 26.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public struct Position: Equatable {
    public typealias Coordinate = Float

    private var _x: Coordinate
    public var x: Coordinate {
        get {
            return _x
        }
        set {
            _x = abs(newValue).truncatingRemainder(dividingBy: 1.0)
        }
    }
    private var _y: Coordinate
    public var y: Coordinate {
        get {
            return _y
        }
        set {
            _y = abs(newValue).truncatingRemainder(dividingBy: 1.0)
        }
    }

    public init(x: Coordinate, y: Coordinate) {
        _x = abs(x).truncatingRemainder(dividingBy: 1.0)
        _y = abs(y).truncatingRemainder(dividingBy: 1.0)
    }

    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

public extension Position {
    private func minabs(_ lhs: Coordinate, _ rhs: Coordinate) -> Coordinate {
        if abs(lhs) <= abs(rhs) {
            return lhs
        } else {
            return rhs
        }
    }

    private func direction(_ left: Coordinate, _ right: Coordinate) -> Float {
        let diff = minabs(
            (left - right).remainder(dividingBy: 1.0),
            (left - (right + 0.5).remainder(dividingBy: 1.0)).remainder(dividingBy: 1.0))
        return diff * -4.0
    }

    public func horizontalDirection(to: Position) -> Float {
        return direction(x, to.x)
    }

    public func verticalDirection(to: Position) -> Float {
        return direction(x, to.x)
    }
}
