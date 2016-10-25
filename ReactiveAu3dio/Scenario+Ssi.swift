//
//  Scenario+Ssi.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import EasyInject

public extension Provider {
    public static var scenarios: SsiProvider<[Scenario]> {
        return .derive()
    }
}

import ValidatedExtension

public struct SsiHasScenarios: Validator {
    public static func validate(_ value: Ssi) throws -> Bool {
        _ = try value.resolving(from: .scenarios)
        return true
    }
}

public extension ValidatedType where Self.ValidatorType == SsiHasScenarios {
    public var scenarios: [Scenario] {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .scenarios)
    }
}

public typealias SsiWithScenarios = Validated<SsiHasScenarios>
