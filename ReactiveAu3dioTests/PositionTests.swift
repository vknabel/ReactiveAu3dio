//
//  PositionTests.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 26.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

@testable import ReactiveAu3dio

import Quick
import Nimble

final class PositionTests: QuickSpec {
    override func spec() {
        describe("directions between positions") {
            it("shall return the right horizontal direction") {
                let west = Position(x: 0.0, y: 0.0)
                let north = Position(x: 0.25, y: 0.0)
                let east = Position(x: 0.5, y: 0.0)
                let south = Position(x: 0.75, y: 0.0)

                let left = -1.0
                let center = 0.0
                let right = 1.0
                let behind = center

                func dir(_ lhs: Position, _ rhs: Position) -> Expectation<Double> {
                    return expect(lhs.horizontalDirection(to: rhs))
                }

                dir(west, south) == left
                dir(west, west) == center
                dir(west, north) == right
                dir(west, east) == behind

                dir(north, west) == left
                dir(north, north) == center
                dir(north, east) == right
                dir(north, south) == behind
                
                dir(east, north) == left
                dir(east, east) == center
                dir(east, south) == right
                dir(east, west) == behind
                
                dir(south, east) == left
                dir(south, south) == center
                dir(south, west) == right
                dir(south, north) == behind
            }

            it("shall return the right vertical direction") {
                let west = Position(x: 0.0, y: 0.0)
                let north = Position(x: 0.25, y: 0.0)
                let east = Position(x: 0.5, y: 0.0)
                let south = Position(x: 0.75, y: 0.0)

                let left = -1.0
                let center = 0.0
                let right = 1.0
                let behind = center

                func dir(_ lhs: Position, _ rhs: Position) -> Expectation<Double> {
                    return expect(lhs.verticalDirection(to: rhs))
                }

                dir(west, south) == left
                dir(west, west) == center
                dir(west, north) == right
                dir(west, east) == behind

                dir(north, west) == left
                dir(north, north) == center
                dir(north, east) == right
                dir(north, south) == behind

                dir(east, north) == left
                dir(east, east) == center
                dir(east, south) == right
                dir(east, west) == behind

                dir(south, east) == left
                dir(south, south) == center
                dir(south, west) == right
                dir(south, north) == behind
            }
        }
    }
}
