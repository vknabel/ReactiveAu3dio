import EasyInject
import ValidatedExtension

public struct ScenarioHasName: Validator {
    public typealias WrappedType = Scenario

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

public typealias ScenarioWithName = Validated<ScenarioHasName>
