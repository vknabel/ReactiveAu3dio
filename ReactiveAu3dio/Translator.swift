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
}

public struct DataToReferenceTranslator<Index: Hashable, Data, Reference: Hashable> {
    public let indexFromData: (Data) -> Index
    public let applyToReference: (Data) -> (Reference?) -> Reference?
    public let performReferenceChanges: (Changes<Reference>) -> Void

    public init(indexFromData: @escaping (Data) -> Index, applyToReference: @escaping (Data) -> (Reference?) -> Reference?, performReferenceChanges: @escaping (Changes<Reference>) -> Void) {
        self.indexFromData = indexFromData
        self.applyToReference = applyToReference
        self.performReferenceChanges = performReferenceChanges
    }

    public func references(from data: Observable<[Data]>) -> Observable<[Index: Reference]> {
        return data.scan([Index: Reference]()) { previous, data in
            var next = [Index: Reference]()
            for d in data {
                let index = self.indexFromData(d)
                next[index] = self.applyToReference(d)(previous[index])
            }
            return next
        }
    }

    public func referenceChanges(references: Observable<[Index: Reference]>) -> Observable<Changes<Reference>> {
        return references.scan(Changes()) { changes, next in
            return Changes(previous: changes.current, next: Set(next.values))
        }
    }

    public func execute(with dataSource: Observable<[Data]>) -> Observable<Changes<Reference>> {
        return referenceChanges(references: references(from: dataSource))
            .do(onNext: performReferenceChanges)
    }
}
