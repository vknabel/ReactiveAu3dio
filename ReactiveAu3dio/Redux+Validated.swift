import ValidatedExtension

public typealias ValidatedReducer<V: Validator, A: Action> = (Validated<V>, A) -> Ssi where V.WrappedType == Ssi

public func validatedReducer<V: Validator, A: Action>(_ validatedReducer: @escaping ValidatedReducer<V, A>) -> Reducer where V.WrappedType == Ssi {
    return typedReducer({ (ssi: Ssi, action: A) -> Ssi in
        guard let validated = Validated<V>(value: ssi) else { return ssi }
        return validatedReducer(validated, action)
    })
}
