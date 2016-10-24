import EasyInject

public enum ScenarioFieldKey { }
public typealias ScenarioField = GenericProvidableKey<ScenarioFieldKey>

public extension Provider {
    public static var scenarioName: Provider<ScenarioField, String> {
        return .derive()
    }
}

public typealias Scenario = StrictInjector<ScenarioField>
public typealias ScenarioProvider<v> = Provider<ScenarioField, v>

public extension Provider {
    public static var scenarios: SsiProvider<[Scenario]> {
        return .derive()
    }
}
