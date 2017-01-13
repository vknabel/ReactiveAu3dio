// Generated using Sourcery 0.5.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import RxLens
import EasyInject
import ValidatedExtension

// swiftlint:disable vertical_whitespace
// swiftlint:disable file_length

// MARK: - GenerateInjector Types
// MARK: Entity
public enum EntityFieldKey { }
public typealias EntityField = GenericProvidableKey<EntityFieldKey>
public typealias Entity = StrictInjector<EntityField>
public typealias EntityProvider<v> = Provider<EntityField, v>

// MARK: Entity.name
public typealias EntityWithName = Validated<EntityHasName>
public let nameOfEntityLens: Lens<Entity, String?> = .with(injected: .entityName)

// MARK: Entity.image
public typealias EntityWithImage = Validated<EntityHasImage>
public let imageOfEntityLens: Lens<Entity, String?> = .with(injected: .entityImage)

// MARK: Entity.sound
public typealias EntityWithSound = Validated<EntityHasSound>
public let soundOfEntityLens: Lens<Entity, Sound?> = .with(injected: .entitySound)

// MARK: Entity.position
public typealias EntityWithPosition = Validated<EntityHasPosition>
public let positionOfEntityLens: Lens<Entity, Position?> = .with(injected: .entityPosition)
// MARK: Goal
public enum GoalFieldKey { }
public typealias GoalField = GenericProvidableKey<GoalFieldKey>
public typealias Goal = StrictInjector<GoalField>
public typealias GoalProvider<v> = Provider<GoalField, v>

// MARK: Goal.name
public typealias GoalWithName = Validated<GoalHasName>
public let nameOfGoalLens: Lens<Goal, String?> = .with(injected: .goalName)
// MARK: Level
public enum LevelFieldKey { }
public typealias LevelField = GenericProvidableKey<LevelFieldKey>
public typealias Level = StrictInjector<LevelField>
public typealias LevelProvider<v> = Provider<LevelField, v>

// MARK: Level.name
public typealias LevelWithName = Validated<LevelHasName>
public let nameOfLevelLens: Lens<Level, String?> = .with(injected: .levelName)

// MARK: Level.goals
public typealias LevelWithGoals = Validated<LevelHasGoals>
public let goalsOfLevelLens: Lens<Level, [Goal]?> = .with(injected: .levelGoals)

// MARK: Level.background
public typealias LevelWithBackground = Validated<LevelHasBackground>
public let backgroundOfLevelLens: Lens<Level, String?> = .with(injected: .levelBackground)

// MARK: Level.entities
public typealias LevelWithEntities = Validated<LevelHasEntities>
public let entitiesOfLevelLens: Lens<Level, [Entity]?> = .with(injected: .levelEntities)

// MARK: Level.ambients
public typealias LevelWithAmbients = Validated<LevelHasAmbients>
public let ambientsOfLevelLens: Lens<Level, [Sound]?> = .with(injected: .levelAmbients)

// MARK: Level.position
public typealias LevelWithPosition = Validated<LevelHasPosition>
public let positionOfLevelLens: Lens<Level, Position?> = .with(injected: .levelPosition)
// MARK: Scenario
public enum ScenarioFieldKey { }
public typealias ScenarioField = GenericProvidableKey<ScenarioFieldKey>
public typealias Scenario = StrictInjector<ScenarioField>
public typealias ScenarioProvider<v> = Provider<ScenarioField, v>

// MARK: Scenario.name
public typealias ScenarioWithName = Validated<ScenarioHasName>
public let nameOfScenarioLens: Lens<Scenario, String?> = .with(injected: .scenarioName)


// MARK: Ssi.scenarios
public typealias SsiWithScenarios = Validated<SsiHasScenarios>
public let scenariosOfSsiLens: Lens<Ssi, [Scenario]?> = .with(injected: .ssiScenarios)

// MARK: Ssi.currentLevel
public typealias SsiWithCurrentLevel = Validated<SsiHasCurrentLevel>
public let currentLevelOfSsiLens: Lens<Ssi, Level?> = .with(injected: .ssiCurrentLevel)


// MARK: - GenerateInjector Implementation

// MARK: Entity.name

public extension Provider {
    public static var entityName: EntityProvider<String> {
        return .derive()
    }
}

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

// MARK: Entity.image

public extension Provider {
    public static var entityImage: EntityProvider<String> {
        return .derive()
    }
}

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

// MARK: Entity.sound

public extension Provider {
    public static var entitySound: EntityProvider<Sound> {
        return .derive()
    }
}

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

// MARK: Entity.position

public extension Provider {
    public static var entityPosition: EntityProvider<Position> {
        return .derive()
    }
}

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

// MARK: Goal.name

public extension Provider {
    public static var goalName: GoalProvider<String> {
        return .derive()
    }
}

public struct GoalHasName: Validator {
    public static func validate(_ value: Goal) throws -> Bool {
        _ = try value.resolving(from: .goalName)
        return true
    }
}

public extension ValidatedType where ValidatorType == GoalHasName {
    public var name: String {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .goalName)
    }
}

// MARK: Level.name

public extension Provider {
    public static var levelName: LevelProvider<String> {
        return .derive()
    }
}

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

// MARK: Level.goals

public extension Provider {
    public static var levelGoals: LevelProvider<[Goal]> {
        return .derive()
    }
}

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

// MARK: Level.background

public extension Provider {
    public static var levelBackground: LevelProvider<String> {
        return .derive()
    }
}

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

// MARK: Level.entities

public extension Provider {
    public static var levelEntities: LevelProvider<[Entity]> {
        return .derive()
    }
}

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

// MARK: Level.ambients

public extension Provider {
    public static var levelAmbients: LevelProvider<[Sound]> {
        return .derive()
    }
}

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

// MARK: Level.position

public extension Provider {
    public static var levelPosition: LevelProvider<Position> {
        return .derive()
    }
}

public struct LevelHasPosition: Validator {
    public static func validate(_ value: Level) throws -> Bool {
        _ = try value.resolving(from: .levelPosition)
        return true
    }
}

public extension ValidatedType where ValidatorType == LevelHasPosition {
    public var position: Position {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .levelPosition)
    }
}

// MARK: Scenario.name

public extension Provider {
    public static var scenarioName: ScenarioProvider<String> {
        return .derive()
    }
}

public struct ScenarioHasName: Validator {
    public static func validate(_ value: Scenario) throws -> Bool {
        _ = try value.resolving(from: .scenarioName)
        return true
    }
}

public extension ValidatedType where ValidatorType == ScenarioHasName {
    public var name: String {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .scenarioName)
    }
}

// MARK: Ssi.scenarios

public extension Provider {
    public static var ssiScenarios: SsiProvider<[Scenario]> {
        return .derive()
    }
}

public struct SsiHasScenarios: Validator {
    public static func validate(_ value: Ssi) throws -> Bool {
        _ = try value.resolving(from: .ssiScenarios)
        return true
    }
}

public extension ValidatedType where ValidatorType == SsiHasScenarios {
    public var scenarios: [Scenario] {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .ssiScenarios)
    }
}

// MARK: Ssi.currentLevel

public extension Provider {
    public static var ssiCurrentLevel: SsiProvider<Level> {
        return .derive()
    }
}

public struct SsiHasCurrentLevel: Validator {
    public static func validate(_ value: Ssi) throws -> Bool {
        _ = try value.resolving(from: .ssiCurrentLevel)
        return true
    }
}

public extension ValidatedType where ValidatorType == SsiHasCurrentLevel {
    public var currentLevel: Level {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .ssiCurrentLevel)
    }
}

