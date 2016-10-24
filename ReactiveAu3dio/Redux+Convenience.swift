
public func reducer(_ reducer: @escaping Reducer) -> Reducer {
    return reducer
}

public let idReducer = reducer { ssi, action in ssi }

public func typedReducer<A: Action>(_ typedReducer: @escaping TypedReducer<A>) -> Reducer {
    return { ssi, action in
        guard let action = action as? A else { return ssi }
        return typedReducer(ssi, action)
    }
}

public let actionLogger = reducer { ssi, action in
    dump(action)
    return ssi
}

public let stateLogger = reducer { ssi, _ in
    dump(ssi)
    return ssi
}

public func combineReducer(_ lhs: @escaping Reducer, _ rhs: @escaping Reducer) -> Reducer {
    return { ssi, action in
        let rssi = lhs(ssi, action)
        return rhs(rssi, action)
    }
}

public func &(_ lhs: @escaping Reducer, _ rhs: @escaping Reducer) -> Reducer {
    return combineReducer(lhs, rhs)
}
