import ReactiveAu3dio
import RxSwift

import EasyInject

public let ssioObserver = AnyObserver<Ssi> { event in
    switch event {
    case let .next(ssi):
        let elements = ssi.providedKeys
            .flatMap({ (key: SsiElements) -> (key: String, value: Providable)? in
                guard let value = try? ssi.resolving(key: key) else { return nil }
                return (key: key.name, value: value)
            })
        dump(elements, name: "next")
    case let .error(error):
        dump(error, name: "error")
    case .completed:
        print("=> completed")
    }
}
