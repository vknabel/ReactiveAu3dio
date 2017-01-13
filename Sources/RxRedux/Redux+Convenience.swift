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

/// A reducer that ignores all actions of a different type.
public typealias ActionReducer<A: Action> = (Ssi, A) -> Ssi

/// Creates a reducer that will only be triggered if the action type matches.
///
/// - Parameter actionType: The type of all triggering actions.
/// - Parameter actionReducer: An `ActionReducer` that takes the `Ssi` and the action.
/// - Returns: A `Reducer` with the given semantics.
public func actionReducer<A: Action>(actionOf actionType: A.Type = A.self, reducer: @escaping ActionReducer<A>) -> Reducer {
    return { ssi, action in
        guard let action = action as? A else { return ssi }
        return reducer(ssi, action)
    }
}

/// A reducer that logs all actions.
/// Useful for debugging.
public let actionLogger = reducer { ssi, action in
    dump(action)
    return ssi
}

/// A reducer that logs all states.
/// Useful for debugging.
public let stateLogger = reducer { ssi, _ in
    dump(ssi)
    return ssi
}

/// Combines two reducers into one.
///
/// - Parameter lhs: The reducer that will be executed first.
/// - Parameter rhs: The reducer that takes the result of `lhs`.
/// - Returns: The combined reducer with the same semantics.
public func combineReducer(_ lhs: @escaping Reducer, _ rhs: @escaping Reducer) -> Reducer {
    return { ssi, action in
        let rssi = lhs(ssi, action)
        return rhs(rssi, action)
    }
}

/// Combines two reducers into one.
///
/// - Parameter lhs: The reducer that will be executed first.
/// - Parameter rhs: The reducer that takes the result of `lhs`.
/// - Returns: The combined reducer with the same semantics.
public func & (_ lhs: @escaping Reducer, _ rhs: @escaping Reducer) -> Reducer {
    return combineReducer(lhs, rhs)
}

import ValidatedExtension

/// A reducer that validates the `Ssi` and requires a specific action type.
public typealias ValidatedReducer<V: Validator, A: Action> = (Validated<V>, A) -> Ssi where V.WrappedType == Ssi

/// Creates a new reducer that will only be triggered on validated values and on fitting actions.
///
/// - Parameter validatorType: The type of the `Ssi`-validator.
/// - Parameter actionType: The type of accepted actions.
/// - Parameter validatedReducer: A reducer that takes validated `Ssi`s  and actions.
/// - Returns: A reducer with the given semantics.
public func validatedReducer<V: Validator, A: Action>(validatorOf validatorType: V.Type = V.self, actionOf actionType: A.Type = A.self, reducer: @escaping ValidatedReducer<V, A>) -> Reducer where V.WrappedType == Ssi {
    return actionReducer(reducer: { (ssi: Ssi, action: A) -> Ssi in
        guard let validated = Validated<V>(value: ssi) else { return ssi }
        return reducer(validated, action)
    })
}

import RxLens

/// Creates a lens reducer that will only accept specific actions.
///
/// - Parameter actionType: The type of accepted actions.
/// - Parameter lens: The lens that will be used for the reducer.
/// - Parameter reducer: The reducer that performs the actual action.
/// - Returns: A reducer with the given semantics.
public func lensReducer<T, A: Action>(actionOf actionType: A.Type = A.self, _ lens: Lens<Ssi, T>, reducer: @escaping (T, A) -> T) -> Reducer {
    return actionReducer { (ssi: Ssi, action: A) -> Ssi in
        let rawT = lens.from(ssi)
        let resT = reducer(rawT, action)
        return lens.to(resT, ssi)
    }
}

/// Creates a validated lensed reducer. The validator will be applied on the lensed reducer. Only specific action types will be accepted.
///
/// - Parameter validatorType: The type of the lensed `Ssi`.
/// - Parameter actionType: The type of accepted actions.
/// - Parameter lens: The lens that will be used for the reducer.
/// - Parameter reducer: The reducer that performs the actual action.
/// - Returns: A reducer with the given semantics.
public func validatedLensReducer<V: Validator, A: Action>(validatorOf validatorType: V.Type = V.self, actionOf actionType: A.Type = A.self, _ lens: Lens<Ssi, V.WrappedType>, reducer: @escaping (Validated<V>, A) -> V.WrappedType) -> Reducer {
    return lensReducer(lens, reducer: { (unvalidated: V.WrappedType, action: A) -> V.WrappedType in
        guard let validated: Validated<V> = Validated<V>(value: unvalidated) else { return unvalidated }
        return reducer(validated, action)
    })
}
