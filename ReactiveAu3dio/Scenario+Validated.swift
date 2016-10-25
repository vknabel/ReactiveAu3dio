import ValidatedExtension

public struct HasScenarios: Validator {
    public static func validate(_ value: Ssi) throws -> Bool {
        return value.contains(SsiProvider<[Scenario]>.scenarios.key)
    }
}

public extension ValidatedType where Self.ValidatorType.WrappedType == Ssi {
    public var scenarios: [Scenario] {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .scenarios)
    }
}

public struct ScenarioValidator: Validator {
    public typealias WrappedType = Scenario

    public static func validate(_ value: Scenario) throws -> Bool {
        return value.contains(ScenarioProvider<String>.scenarioName.key)
    }
}

public extension ValidatedType where ValidatorType.WrappedType == Scenario {
    public var name: String {
        // will only fail if ValidatorType has a bug
        // swiftlint:disable:next force_try
        return try! value.resolving(from: .scenarioName)
    }
}
