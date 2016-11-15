//
//  maybeEqual.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 15.11.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public func maybeEqual<T: Equatable>(_ lhs: T?, _ rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case let (.some(lhs), .some(rhs)):
        return lhs == rhs
    default:
        return false
    }
}
