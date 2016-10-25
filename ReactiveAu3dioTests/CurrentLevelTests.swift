//
//  CurrentLevelTests.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxSwift
import EasyInject
import ValidatedExtension
@testable import ReactiveAu3dio
import RxTest

import Quick
import Nimble

fileprivate enum CurrentLevelAction: Action {
    case setup
    case load(Level)
}

final class CurrentLevelTestTests: QuickSpec {
    override func spec() {
        describe("ssi has current level") {
            it("will not validate when empty") {
                let ssi = Ssi()
                let isValid = try? SsiHasCurrentLevel.validate(ssi)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let ssi = Ssi().providing(Level(), for: .currentLevel)
                let isValid = try? SsiHasCurrentLevel.validate(ssi)
                expect(isValid) == true
            }
        }

        describe("current level lens") {
            it("doesn't return level when invalid") {
                let ssi = Ssi()
                let level = currentLevelLens.from(ssi)
                expect(level).to(beNil())
            }

            it("returns when valid") {
                let ssi = Ssi().providing(Level(), for: .currentLevel)
                let level = currentLevelLens.from(ssi)
                expect(level).toNot(beNil())
            }

            it("won't change when setting nil when invalid") {
                let ssi = Ssi()
                let updated = currentLevelLens.to(nil, ssi)
                expect(ssi.debugDescription) == updated.debugDescription
            }

            it("will change when setting nil when valid") {
                let ssi = Ssi().providing(Level(), for: .currentLevel)
                let updated = currentLevelLens.to(nil, ssi)
                expect(ssi.debugDescription) != updated.debugDescription
            }

            it("will change when setting level when invalid") {
                let ssi = Ssi()
                let updated = currentLevelLens.to(Level(), ssi)
                expect(ssi.debugDescription) != updated.debugDescription
            }

            it("won't change when setting same level when valid") {
                let ssi = Ssi().providing(Level(), for: .currentLevel)
                let updated = currentLevelLens.to(Level(), ssi)
                expect(ssi.debugDescription) == updated.debugDescription
            }

            it("will change when setting other level when valid") {
                let ssi = Ssi().providing(Level(), for: .currentLevel)
                let updated = currentLevelLens.to(Level().providing("Name", for: .levelName), ssi)
                expect(ssi.debugDescription) != updated.debugDescription
            }

            it("will only execute lensed reducers when valid") {
                let scheduler: TestScheduler = TestScheduler(initialClock: 0)
                let initial = Ssi()

                var executed = false
                let main = Store(
                    initial: scheduler.createColdObservable([
                            next(100, initial)
                        ]
                    ),
                    reducers: [
                        lensReducer(actionOf: CurrentLevelAction.self, currentLevelLens, reducer: { (level, action) -> Level? in
                            executed = true
                            return level
                        })
                    ]
                )

                _ = main.ssio.subscribe()
                scheduler.start()

                expect(executed) == false
                main.next(CurrentLevelAction.setup)
                expect(executed) == true
            }
        }
    }
}
