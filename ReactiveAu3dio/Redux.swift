import EasyInject
import RxSwift

public enum RootElementKey { }
public typealias RootElements = GenericProvidableKey<RootElementKey>
public typealias Ssi = StrictInjector<RootElements>
public typealias RootProvider<v> = Provider<RootElements, v>

public protocol Action { }

public enum SdiKey { }
public typealias SdiElements = GenericProvidableKey<SdiKey>
public typealias SdiInjector = StrictInjector<SdiElements>
public typealias SdiProvider<v: Providable> = Provider<SdiElements, v>

public struct Store {
    public let aao: AnyObserver<Action>
    public let ssio: Observable<Ssi>
    public let sdi: Sdi

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

public extension Store {
    public func next(_ action: Action) {
        self.aao.onNext(action)
    }

    public func completed() {
        self.aao.onCompleted()
    }
}

public typealias Reducer = (Ssi, Action) -> Ssi
public typealias ActionReducer<A: Action> = (Ssi, A) -> Ssi
public typealias Sdi = SdiInjector
