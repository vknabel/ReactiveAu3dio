//
//  StoreConvenienceSpec.swift
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

fileprivate enum OneAction: Action {
    case one
}
fileprivate enum OtherAction: Action {
    case other
}

final class StoreConvenienceTests: QuickSpec {
    override func spec() {
        describe("reducer function") {
            it("keeps semantics") {
                let red: Reducer = { ssi, action in
                    return ssi
                }
                let ssi = Ssi()
                let action = OneAction.one
                expect(red(ssi, action).debugDescription) == reducer(red)(ssi, action).debugDescription
            }
        }

        describe("typed reducer function") {
            it("will ignore different types") {
                var executed = false
                let typed = typedReducer { (ssi: Ssi, action: OneAction) in
                    executed = true
                    return ssi
                }

                let ssi = Ssi()
                expect(executed) == false
                _ = typed(ssi, OtherAction.other)
                expect(executed) == false
                _ = typed(ssi, OneAction.one)
                expect(executed) == true
            }

            it("will be executed on same type") {
                var executed = false
                let typed = typedReducer { (ssi: Ssi, action: OneAction) in
                    executed = true
                    return ssi
                }

                let ssi = Ssi()
                expect(executed) == false
                _ = typed(ssi, OneAction.one)
                expect(executed) == true
            }
        }

        describe("combine reducer") {
            it("executes both") {
                var (executedLeft, executedRight) = (false, false)
                let reducer = combineReducer(
                    { ssi, _ in executedLeft = true; return ssi },
                    { ssi, _ in executedRight = true; return ssi }
                )

                let ssi = Ssi()
                expect(executedLeft) == false
                expect(executedRight) == false
                _ = reducer(ssi, OneAction.one)
                expect(executedLeft) == true
                expect(executedRight) == true
            }

            it("operator executes both") {
                var (executedLeft, executedRight) = (false, false)
                let reducer = { ssi, _ in executedLeft = true; return ssi }
                    & { ssi, _ in executedRight = true; return ssi }

                let ssi = Ssi()
                expect(executedLeft) == false
                expect(executedRight) == false
                _ = reducer(ssi, OneAction.one)
                expect(executedLeft) == true
                expect(executedRight) == true
            }

            it("operator equals reducer") {
                let operatorReducer = { ssi, _ in ssi }
                    & { ssi, _ in ssi }
                let combinedReducer = combineReducer(
                    { ssi, _ in ssi },
                    { ssi, _ in ssi }
                )

                let ssi = Ssi()
                let opResult = operatorReducer(ssi, OneAction.one).debugDescription
                let coResult = combinedReducer(ssi, OneAction.one).debugDescription
                expect(opResult) == coResult
            }
        }
    }
}
