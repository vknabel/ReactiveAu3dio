import EasyInject

public extension Provider {
    public static var counter: RootProvider<Int> {
        return .derive()
    }
}

public enum CounterAction: Action {
    case increase
    case decrease

    public static var reducer: Reducer = typedReducer { (ssi: Ssi, action: CounterAction) in
        var state = ssi
        let current = (try? state.resolve(from: .counter)) ?? 0
        state.revoke(for: .counter)

        switch action {
        case .increase:
            return state.providing(current + 1, for: .counter)
        case .decrease:
            return state.providing(current - 1, for: .counter)
        }
    }

    public static var logger: Reducer = typedReducer { (ssi: Ssi, action: CounterAction) in
        var ssi = ssi
        let counter = (try? ssi.resolve(from: .counter)) ?? 0
        print("-", "CounterAction.\(action)", "=>", counter)
        return ssi
    }
}
