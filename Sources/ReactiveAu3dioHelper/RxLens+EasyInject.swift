//
//  RxLens+EasyInject.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 15.11.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxLens
import EasyInject

public extension Lens where A: Injector {
    public static func with<T>(injected provider: Provider<A.Key, T>) -> Lens<A, T?> {
        return Lens<A, T?>(
            from: { (injector: A) -> T? in
                let optional: T? = try? injector.resolving(from: provider)
                return optional
            },
            to: { property, entity in
                if let property = property {
                    return entity.providing(property, for: provider)
                } else {
                    return entity.revoking(for: provider)
                }
            }
        )
    }
}
