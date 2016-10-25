//
//  LevelFieldsTests.swift
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

final class LevelFieldsTests: QuickSpec {
    override func spec() {
        // MARK: Name
        describe("level name provider") {
            it("is deterministic") {
                let firstProvider: LevelProvider = .levelName
                let secondProvider: LevelProvider = .levelName
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("level has name validator") {
            it("will not validate when empty") {
                let level = Level()
                let isValid = try? LevelHasName.validate(level)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let level = Level().providing("Level Name", for: .levelName)
                let isValid = try? LevelHasName.validate(level)
                expect(isValid) == true
            }
        }

        // MARK: Goals
        describe("level goals provider") {
            it("is deterministic") {
                let firstProvider: LevelProvider = .levelGoals
                let secondProvider: LevelProvider = .levelGoals
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("level has goals validator") {
            it("will not validate when empty") {
                let level = Level()
                let isValid = try? LevelHasGoals.validate(level)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let level = Level().providing([], for: .levelGoals)
                let isValid = try? LevelHasGoals.validate(level)
                expect(isValid) == true
            }
        }

        // MARK: Background
        describe("level background provider") {
            it("is deterministic") {
                let firstProvider: LevelProvider = .levelBackground
                let secondProvider: LevelProvider = .levelBackground
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("level has background validator") {
            it("will not validate when empty") {
                let level = Level()
                let isValid = try? LevelHasBackground.validate(level)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let level = Level().providing("background.png", for: .levelBackground)
                let isValid = try? LevelHasBackground.validate(level)
                expect(isValid) == true
            }
        }

        // MARK: Entities
        describe("level entities provider") {
            it("is deterministic") {
                let firstProvider: LevelProvider = .levelEntities
                let secondProvider: LevelProvider = .levelEntities
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("level has entities validator") {
            it("will not validate when empty") {
                let level = Level()
                let isValid = try? LevelHasEntities.validate(level)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let level = Level().providing([], for: .levelEntities)
                let isValid = try? LevelHasEntities.validate(level)
                expect(isValid) == true
            }
        }

        // MARK: Ambients
        describe("level ambients provider") {
            it("is deterministic") {
                let firstProvider: LevelProvider = .levelAmbients
                let secondProvider: LevelProvider = .levelAmbients
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("level has ambients validator") {
            it("will not validate when empty") {
                let level = Level()
                let isValid = try? LevelHasAmbients.validate(level)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let level = Level().providing([], for: .levelAmbients)
                let isValid = try? LevelHasAmbients.validate(level)
                expect(isValid) == true
            }
        }

        // MARK: All
        describe("level field providers") {
            it("are all different") {
                let name: LevelProvider = .levelName
                let goals: LevelProvider = .levelGoals
                let background: LevelProvider = .levelBackground
                let entities: LevelProvider = .levelEntities
                let ambients: LevelProvider = .levelAmbients

                expect(name.key) != goals.key
                expect(name.key) != background.key
                expect(name.key) != entities.key
                expect(name.key) != ambients.key

                expect(goals.key) != name.key
                expect(goals.key) != background.key
                expect(goals.key) != entities.key
                expect(goals.key) != ambients.key

                expect(background.key) != name.key
                expect(background.key) != goals.key
                expect(background.key) != entities.key
                expect(background.key) != ambients.key

                expect(entities.key) != name.key
                expect(entities.key) != goals.key
                expect(entities.key) != background.key
                expect(entities.key) != ambients.key

                expect(ambients.key) != name.key
                expect(ambients.key) != goals.key
                expect(ambients.key) != background.key
                expect(ambients.key) != entities.key
            }
        }
    }
}
