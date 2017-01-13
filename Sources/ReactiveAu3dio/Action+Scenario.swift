import ValidatedExtension

public enum ScenarioAction: Action {
    case append(Scenario)

    var name: String {
        switch self {
        case .append(_):
            return "append"
        }
    }

    public static var reducer = validatedReducer(
        validatorOf: SsiHasScenarios.self,
        actionOf: ScenarioAction.self,
        reducer: { validated, action in
            switch action {
            case let .append(newScenario):
                var scenarios = validated.scenarios
                scenarios.append(newScenario)
                print(scenarios.count)
                var value = validated.value
                value.revoke(for: .ssiScenarios)
                value.provide(scenarios, for: .ssiScenarios)
                return value
            }
    })

    public static var logger: Reducer = actionReducer { (ssi: Ssi, action: ScenarioAction) in
        var ssi = ssi
        let scenarios = (try? ssi.resolve(from: .ssiScenarios)) ?? []
        print("-", "ScenarioAction.\(action.name)")
        return ssi
    }
}
