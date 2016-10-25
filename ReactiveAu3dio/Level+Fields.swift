//
//  Level.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import EasyInject

public extension Provider {
    public static var levelName: LevelProvider<String> {
        return .derive()
    }
    public static var levelGoals: LevelProvider<[Goal]> {
        return .derive()
    }
    public static var levelBackground: LevelProvider<String> {
        return .derive()
    }
    public static var levelEntities: LevelProvider<[Entity]> {
        return .derive()
    }
    public static var levelAmbients: LevelProvider<[Sound]> {
        return .derive()
    }
}

import ValidatedExtension

// MARK: Name

public struct LevelHasName: Validator {
    public static func validate(_ value: Level) throws -> Bool {
        _ = try value.resolving(from: .levelName)
        return true
    }
}
public extension ValidatedType where ValidatorType == LevelHasName {
    public var name: String {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .levelName)
    }
}
public typealias LevelWithName = Validated<LevelHasName>

// MARK: Goals
public struct LevelHasGoals: Validator {
    public static func validate(_ value: Level) throws -> Bool {
        _ = try value.resolving(from: .levelGoals)
        return true
    }
}
public extension ValidatedType where ValidatorType == LevelHasGoals {
    public var goals: [Goal] {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .levelGoals)
    }
}
public typealias LevelWithGoals = Validated<LevelHasGoals>

// MARK: Background

public struct LevelHasBackground: Validator {
    public static func validate(_ value: Level) throws -> Bool {
        _ = try value.resolving(from: .levelBackground)
        return true
    }
}
public extension ValidatedType where ValidatorType == LevelHasBackground {
    public var background: String {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .levelBackground)
    }
}
public typealias LevelWithBackground = Validated<LevelHasBackground>

// MARK: Entities

public struct LevelHasEntities: Validator {
    public static func validate(_ value: Level) throws -> Bool {
        _ = try value.resolving(from: .levelEntities)
        return true
    }
}
public extension ValidatedType where ValidatorType == LevelHasEntities {
    public var entities: [Entity] {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .levelEntities)
    }
}
public typealias LevelWithEntities = Validated<LevelHasEntities>

// MARK: Ambients

public struct LevelHasAmbients: Validator {
    public static func validate(_ value: Level) throws -> Bool {
        _ = try value.resolving(from: .levelAmbients)
        return true
    }
}
public extension ValidatedType where ValidatorType == LevelHasAmbients {
    public var ambients: [Sound] {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .levelAmbients)
    }
}
public typealias LevelWithAmbients = Validated<LevelHasAmbients>
