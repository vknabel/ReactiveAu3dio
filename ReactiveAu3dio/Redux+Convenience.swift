/// Just returns a given reducer.
/// Use this function for better readability.
///
/// - Parameter reducer: The returned reducer.
/// - Returns: The given reducer.
@inline(__always) public func reducer(_ reducer: @escaping Reducer) -> Reducer {
    return reducer
}

/// A reducer that will always keep the `Ssi` untouched.
public let idReducer = reducer { ssi, _ in ssi }

/// Creates a reducer that will only be triggered if the action type matches.
///
/// - Parameter actionType: The type of all triggering actions.
/// - Parameter actionReducer: An `ActionReducer` that takes the `Ssi` and the action.
/// - Returns: A `Reducer` with the given semantics.
public func actionReducer<A: Action>(actionOf actionType: A.Type = A.self, _ actionReducer: @escaping ActionReducer<A>) -> Reducer {
    return { ssi, action in
        guard let action = action as? A else { return ssi }
        return actionReducer(ssi, action)
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

import ValidatedExtension

public typealias ValidatedReducer<V: Validator, A: Action> = (Validated<V>, A) -> Ssi where V.WrappedType == Ssi

public func validatedReducer<V: Validator, A: Action>(validatorOf validatorType: V.Type = V.self, actionOf actionType: A.Type = A.self, _ validatedReducer: @escaping ValidatedReducer<V, A>) -> Reducer where V.WrappedType == Ssi {
    return actionReducer({ (ssi: Ssi, action: A) -> Ssi in
        guard let validated = Validated<V>(value: ssi) else { return ssi }
        return validatedReducer(validated, action)
    })
}

/// Enables read and copy-on-write acces for an entity's property in a datastructure.
///
/// Some examples can be found in this [blog post](http://chris.eidhof.nl/post/lenses-in-swift/).
public struct Lens<A, B> {
    public let from: (A) -> B
    public let to: (B, A) -> A

    public init(from: @escaping (A) -> B, to: @escaping (B, A) -> A) {
        self.from = from
        self.to = to
    }
}

public func lensReducer<T, A: Action>(actionOf actionType: A.Type = A.self, _ lens: Lens<Ssi, T>, _ lensReducer: @escaping (T, A) -> T) -> Reducer {
    return actionReducer { (ssi: Ssi, action: A) -> Ssi in
        let rawT = lens.from(ssi)
        let resT = lensReducer(rawT, action)
        return lens.to(resT, ssi)
    }
}

public func validatedLensReducer<V: Validator, A: Action>(validatorOf validatorType: V.Type = V.self, actionOf actionType: A.Type = A.self, _ lens: Lens<Ssi, V.WrappedType>, _ validatedLensReducer: @escaping (Validated<V>, A) -> V.WrappedType) -> Reducer {
    return lensReducer(lens, { (unvalidated: V.WrappedType, action: A) -> V.WrappedType in
        guard let validated: Validated<V> = Validated<V>(value: unvalidated) else { return unvalidated }
        return validatedLensReducer(validated, action)
    })
}
