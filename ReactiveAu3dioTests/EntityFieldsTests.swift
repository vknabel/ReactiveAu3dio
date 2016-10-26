//
//  EntityFieldsTests.swift
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

final class EntityFieldsTests: QuickSpec {
    override func spec() {
        // MARK: Name
        describe("entity name provider") {
            it("is deterministic") {
                let firstProvider: EntityProvider = .entityName
                let secondProvider: EntityProvider = .entityName
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("entity has name validator") {
            it("will not validate when empty") {
                let entity = Entity()
                let isValid = try? EntityHasName.validate(entity)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let entity = Entity().providing("Entity Name", for: .entityName)
                let isValid = try? EntityHasName.validate(entity)
                expect(isValid) == true
            }
        }

        describe("entity with name") {
            it("can't be constructed when invalid") {
                let entity = Entity()
                let validated = EntityWithName(value: entity)
                expect(validated?.name).to(beNil())
            }
            it("allows to access the field when valid") {
                let entity = Entity().providing("Entity Name", for: .entityName)
                let validated = EntityWithName(value: entity)
                expect(validated?.name) == "Entity Name"
            }
        }

        // MARK: Image
        describe("entity image provider") {
            it("is deterministic") {
                let firstProvider: EntityProvider = .entityImage
                let secondProvider: EntityProvider = .entityImage
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("entity has image validator") {
            it("will not validate when empty") {
                let entity = Entity()
                let isValid = try? EntityHasImage.validate(entity)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let entity = Entity().providing("entity.png", for: .entityImage)
                let isValid = try? EntityHasImage.validate(entity)
                expect(isValid) == true
            }
        }

        describe("entity with image") {
            it("can't be constructed when invalid") {
                let entity = Entity()
                let validated = EntityWithImage(value: entity)
                expect(validated?.image).to(beNil())
            }
            it("allows to access the field when valid") {
                let entity = Entity().providing("entity.png", for: .entityImage)
                let validated = EntityWithImage(value: entity)
                expect(validated?.image) == "entity.png"
            }
        }

        // MARK: Sound
        describe("entity sound provider") {
            it("is deterministic") {
                let firstProvider: EntityProvider = .entitySound
                let secondProvider: EntityProvider = .entitySound
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("entity has sound validator") {
            it("will not validate when empty") {
                let entity = Entity()
                let isValid = try? EntityHasSound.validate(entity)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let sound = Sound(file: "file", volume: 1.0)
                let entity = Entity().providing(sound, for: .entitySound)
                let isValid = try? EntityHasSound.validate(entity)
                expect(isValid) == true
            }
        }

        describe("entity with sound") {
            it("can't be constructed when invalid") {
                let entity = Entity()
                let validated = EntityWithSound(value: entity)
                expect(validated?.sound).to(beNil())
            }
            it("allows to access the field when valid") {
                let sound = Sound(file: "file", volume: 1.0)
                let entity = Entity().providing(sound, for: .entitySound)
                let validated = EntityWithSound(value: entity)
                expect(validated?.sound) == sound
            }
        }

        // MARK: Position
        describe("entity position provider") {
            it("is deterministic") {
                let firstProvider: EntityProvider = .entityPosition
                let secondProvider: EntityProvider = .entityPosition
                expect(firstProvider.key) == secondProvider.key
            }
        }

        describe("entity has position validator") {
            it("will not validate when empty") {
                let entity = Entity()
                let isValid = try? EntityHasPosition.validate(entity)
                expect(isValid).to(beFalsy())
            }

            it("will validate when set") {
                let position = Position(x: 0.3, y: 0.5)
                let entity = Entity().providing(position, for: .entityPosition)
                let isValid = try? EntityHasPosition.validate(entity)
                expect(isValid) == true
            }
        }

        describe("entity with position") {
            it("can't be constructed when invalid") {
                let entity = Entity()
                let validated = EntityWithPosition(value: entity)
                expect(validated?.position).to(beNil())
            }
            it("allows to access the field when valid") {
                let position: Position = Position(x: 0.3, y: 0.5)
                let entity = Entity().providing(position, for: .entityPosition)
                let validated = EntityWithPosition(value: entity)
                expect(validated?.position.x) == position.x
                expect(validated?.position.y) == position.y
            }
        }

        // MARK: All
        describe("entity field providers") {
            it("are all different") {
                let name: EntityProvider = .entityName
                let image: EntityProvider = .entityImage
                let sound: EntityProvider = .entitySound
                let position: EntityProvider = .entityPosition

                expect(name.key) != image.key
                expect(name.key) != sound.key
                expect(name.key) != position.key

                expect(image.key) != name.key
                expect(image.key) != sound.key
                expect(image.key) != position.key

                expect(sound.key) != name.key
                expect(sound.key) != image.key
                expect(sound.key) != position.key

                expect(position.key) != name.key
                expect(position.key) != image.key
                expect(position.key) != sound.key
            }
        }
    }
}
