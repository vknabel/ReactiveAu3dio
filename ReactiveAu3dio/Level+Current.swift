//
//  Level+Current.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import EasyInject
import ValidatedExtension

public extension Provider {
    public static var currentLevel: SsiProvider<Level> {
        return .derive()
    }
}

public struct SsiHasCurrentLevel: Validator {
    public static func validate(_ value: Ssi) throws -> Bool {
        _ = try value.resolving(from: .currentLevel)
        return true
    }
}

public typealias SsiWithCurrentLevel = Validated<SsiHasCurrentLevel>

public extension ValidatedType where Self.ValidatorType == SsiHasCurrentLevel {
    public var currentLevel: Level {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .currentLevel)
    }
}

import RxLens

public let currentLevelLens = Lens(
    from: { (ssi: Ssi) -> Level? in
        guard let ssi = SsiWithCurrentLevel(value: ssi) else { return nil }
        return ssi.currentLevel
    },
    to: { (level: Level?, ssi: Ssi) -> Ssi in
        if let level = level {
            return ssi.providing(level, for: .currentLevel)
        } else {
            return ssi.revoking(for: .currentLevel)
        }
    }
)
