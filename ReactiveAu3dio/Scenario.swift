import EasyInject

public extension Provider {
    public static var scenarioName: Provider<ScenarioField, String> {
        return .derive()
    }
}
