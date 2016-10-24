import EasyInject
import RxSwift

/// A key without any behavior. Used for `SsiElements` and `Ssi`.
public enum SsiElementKey { }
/// The key for elements of the `Ssi`.
public typealias SsiElements = GenericProvidableKey<SsiElementKey>
/// The Single Shared Injector. All data will be stored in this injector.
public typealias Ssi = StrictInjector<SsiElements>
/// An abbreviation for providers targeting the `Ssi`.
public typealias SsiProvider<v> = Provider<SsiElements, v>

/// Adopt this protocol in order to declare actions.
public protocol Action { }

/// A key without any behavior. Used for `SdiElements` and `SdiInjector`.
public enum SdiKey { }
/// The key for elements of the `Sdi`.
public typealias SdiElements = GenericProvidableKey<SdiKey>
/// The single disposable injector. Add all your disposables in here.
public typealias Sdi = StrictInjector<SdiElements>
/// An abbreviation for providers targeting the `Sdi`.
public typealias SdiProvider<v: Providable> = Provider<SdiElements, v>

/// A reducer applies actions to the `Ssi`.
/// It takes the current `Ssi` and the action and returns the new one.
public typealias Reducer = (Ssi, Action) -> Ssi

/// The central store for all data and subscriptions. Listens for all actions.
public struct Store {
    /// Observes for actions. All actions will be reduced one after another.
    public let aao: AnyObserver<Action>
    /// Emits the current `Ssi` once all actions have been applied.
    public let ssio: Observable<Ssi>
    /// Stores all disposables associated for keys.
    public let sdi: Sdi

    /// Creates a new store.
    ///
    /// - Parameter initialStream: Used in order to determine the very first `Ssi`. Further results will be ignored.
    /// - Parameter reducers: All reducers to handle the incoming actions.
    public init<IO: ObservableType>(initial initialStream: IO, reducers: [Reducer]) where IO.E == Ssi {
        let actionSubject = PublishSubject<Action>()
        aao = actionSubject.asObserver()
        sdi = Sdi()
        let actions = actionSubject.asObservable()
        ssio = initialStream.single().flatMap { (initial: Ssi) -> Observable<Ssi> in
            return Observable.just(initial).concat(actions.scan(initial, accumulator: { rootInjector, action in
                return reducers.reduce(rootInjector, { rootInjector, reducer in
                    reducer(rootInjector, action)
                })
            }))
        }
    }
}

/// Adds convenience methods for actions.
public extension Store {
    /// Inserts a new action that shall be applied.
    public func next(_ action: Action) {
        self.aao.onNext(action)
    }

    /// Completes the whole store. The ssio won't emit any `Ssi` once all actions have been processed.
    public func completed() {
        self.aao.onCompleted()
    }
}
