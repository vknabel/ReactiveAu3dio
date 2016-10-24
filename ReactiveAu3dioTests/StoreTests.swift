//
//  File.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 24.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxSwift
import EasyInject
import ValidatedExtension
@testable import ReactiveAu3dio
import RxBlocking
import RxTest

import Quick
import Nimble

final class StoreTests: QuickSpec {
    override func spec() {
        describe("the store") {
            it("will only be executed when subscribed") {
                var executed = false
                let initial = Ssi().providing([], for: .scenarios)
                let initialStream = Observable.just(initial).do { _ in
                    executed = true
                }
                let main = Store(
                    initial: initialStream,
                    reducers: []
                )

                expect(executed).to(beFalse())

                let blocking = main.ssio.toBlocking(timeout: 1)
                _ = try! blocking.first()!
                expect(executed).to(beTrue())
            }

            it("returns intial state by default") {
                let initial = Ssi().providing([], for: .scenarios)
                let initialStream = Observable.just(initial)
                let main = Store(
                    initial: initialStream,
                    reducers: []
                )

                let blocking = main.ssio.toBlocking(timeout: 1)
                let first = try! blocking.first()!
                expect(first.debugDescription) == initial.debugDescription
            }

            it("skips further initials") {
                let scheduler = TestScheduler(initialClock: 0)
                let initial = Ssi().providing([], for: .scenarios)
                let initialStream = scheduler.createColdObservable([
                    next(100, initial),
                    next(100, initial)
                    ]
                )
                let main = Store(
                    initial: initialStream,
                    reducers: []
                )

                var counter = 0
                _ = main.ssio.subscribe(onNext: { _ in counter += 1 })
                scheduler.start()
                main.completed()
                expect(counter) == 1
            }

            it("won't apply reducers by default") {
                let initial = Ssi().providing([], for: .scenarios)
                let initialStream = Observable.just(initial)
                let main = Store(
                    initial: initialStream,
                    reducers: [CounterAction.reducer]
                )

                let blocking = main.ssio.toBlocking(timeout: 1)
                let first = try! blocking.first()!
                expect(first.debugDescription) == initial.debugDescription
            }

            it("completes when actions complete") {
                let initial = Ssi().providing([], for: .scenarios)
                let initialStream = Observable.just(initial)
                let main = Store(
                    initial: initialStream,
                    reducers: []
                )


                let blocking = main.ssio.toBlocking(timeout: 1)
                main.completed()
                let ssis = try! blocking.toArray()
                expect(ssis.count) == 1
            }

            it("invokes reducer after first action") {
                let scheduler = TestScheduler(initialClock: 0)

                var executed = false
                let initial = Ssi().providing([], for: .scenarios)
                let initialStream = scheduler.createColdObservable([next(100, initial)])
                let main = Store(
                    initial: initialStream,
                    reducers: [CounterAction.reducer, { ssi, action in executed = true; return ssi }]
                )

                _ = main.ssio.subscribe()
                scheduler.start()
                
                expect(executed) == false
                main.next(CounterAction.increase)
                expect(executed) == true
            }
        }
    }
}
