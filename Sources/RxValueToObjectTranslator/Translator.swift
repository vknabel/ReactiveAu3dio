//
//  Translator.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 11.11.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxSwift

public struct Changes<V: Hashable> {
    public let current: Set<V>
    public let removed: Set<V>
    public let added: Set<V>

    public init() {
        self.init(current: [], removed: [], added: [])
    }

    private init(current: Set<V>, removed: Set<V>, added: Set<V>) {
        self.current = current
        self.removed = removed
        self.added = added
    }

    public init(previous: Set<V>, next: Set<V>) {
        self.init(
            current: next,
            removed: previous.subtracting(next),
            added: next.subtracting(previous)
        )
    }

    public var previous: Set<V> {
        return common.union(removed)
    }

    public var common: Set<V> {
        return current.subtracting(added)
    }

    public func map<T: Hashable>(_ transform: (V) throws -> T) rethrows -> Changes<T> {
        let removed = Set(try self.removed.map(transform))
        let common = Set(try self.common.map(transform))
        let added = Set(try self.added.map(transform))
        return Changes<T>(
            previous: common.union(removed),
            next: common.union(added)
        )
    }

    public func flatMap<T: Hashable>(_ transform: (V) throws -> T?) rethrows -> Changes<T> {
        let removed = Set(try self.removed.flatMap(transform))
        let common = Set(try self.common.flatMap(transform))
        let added = Set(try self.added.flatMap(transform))
        return Changes<T>(
            previous: common.union(removed),
            next: common.union(added)
        )
    }
}

public struct ValueToObjectTranslator<Index: Hashable, Value, Object: Hashable> {
    public typealias IntermediateTranslations = [Index: (value: Value, object: Object)]
    public typealias SummarizedTranslations = (changed: Changes<Index>, translated: IntermediateTranslations)

    public let indexOfValue: (Value) -> Index
    public let updateObjectWithValue: (Value) -> (Object?) -> Object?
    public let performChanges: (SummarizedTranslations) -> Void
    public let commitChanges: (Changes<Object>) -> Void

    public init(
        indexOfValue: @escaping (Value) -> Index,
        updateObjectWithValue: @escaping (Value) -> (Object?) -> Object?,
        performChanges: @escaping (SummarizedTranslations) -> Void = { _ in },
        commitChanges: @escaping (Changes<Object>) -> Void = { _ in }
    ) {
        self.indexOfValue = indexOfValue
        self.updateObjectWithValue = updateObjectWithValue
        self.performChanges = performChanges
        self.commitChanges = commitChanges
    }

    public func translated(values valueStream: Observable<[Value]>) -> Observable<IntermediateTranslations> {
        return valueStream.scan(IntermediateTranslations()) { previous, values in
            var next = IntermediateTranslations()
            for value in values {
                let index = self.indexOfValue(value)
                guard let object = self.updateObjectWithValue(value)(previous[index]?.object) else {
                    continue
                }
                next[index] = (value, object)
            }
            return next
        }
    }

    public func changes(of translations: Observable<IntermediateTranslations>) -> Observable<SummarizedTranslations> {
        return translations.scan((Changes(), [:])) { previous, next in
            let (changes, _) = previous
            return (Changes(previous: changes.current, next: Set(next.keys)), next)
        }
    }

    public func execute(with dataSource: Observable<[Value]>) -> Observable<Changes<Object>> {
        return changes(of: translated(values: dataSource))
            .do(onNext: performChanges)
            .map({ currently in
                return currently.changed.flatMap { index in
                    currently.translated[index]?.object
                }
            })
            .do(onNext: commitChanges)
    }
}
