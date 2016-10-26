//
//  Entity+Fields.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import EasyInject

public extension Provider {
    public static var entityName: EntityProvider<String> {
        return .derive()
    }
    public static var entityImage: EntityProvider<String> {
        return .derive()
    }
    public static var entitySound: EntityProvider<Sound> {
        return .derive()
    }
    public static var entityPosition: EntityProvider<Position> {
        return .derive()
    }
}

import ValidatedExtension

// MARK: Name

public struct EntityHasName: Validator {
    public static func validate(_ value: Entity) throws -> Bool {
        _ = try value.resolving(from: .entityName)
        return true
    }
}
public extension ValidatedType where ValidatorType == EntityHasName {
    public var name: String {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .entityName)
    }
}
public typealias EntityWithName = Validated<EntityHasName>

// MARK: Image

public struct EntityHasImage: Validator {
    public static func validate(_ value: Entity) throws -> Bool {
        _ = try value.resolving(from: .entityImage)
        return true
    }
}
public extension ValidatedType where ValidatorType == EntityHasImage {
    public var image: String {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .entityImage)
    }
}
public typealias EntityWithImage = Validated<EntityHasImage>

// MARK: Sound

public struct EntityHasSound: Validator {
    public static func validate(_ value: Entity) throws -> Bool {
        _ = try value.resolving(from: .entitySound)
        return true
    }
}
public extension ValidatedType where ValidatorType == EntityHasSound {
    public var sound: Sound {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .entitySound)
    }
}
public typealias EntityWithSound = Validated<EntityHasSound>

// MARK: Position

public struct EntityHasPosition: Validator {
    public static func validate(_ value: Entity) throws -> Bool {
        _ = try value.resolving(from: .entityPosition)
        return true
    }
}
public extension ValidatedType where ValidatorType == EntityHasPosition {
    public var position: Position {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .entityPosition)
    }
}
public typealias EntityWithPosition = Validated<EntityHasPosition>
