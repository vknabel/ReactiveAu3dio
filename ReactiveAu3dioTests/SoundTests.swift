//
//  SoundTests.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

@testable import ReactiveAu3dio

import Quick
import Nimble

final class SoundTests: QuickSpec {
    override func spec() {
        describe("sound") {
            it("passes parameters when initialized") {
                let sound = Sound(file: "my file", volume: 0.33)
                expect(sound.file) == "my file"
                expect(sound.volume) == 0.33
            }

            it("is equatable") {
                let first = Sound(file: "first", volume: 1.0)
                let second = Sound(file: "second", volume: 1.0)
                let third = Sound(file: "first", volume: 0.5)

                expect(first) == first
                expect(second) == second
                expect(third) == third

                expect(first) != second
                expect(first) != third

                expect(second) != first
                expect(second) != third

                expect(third) != first
                expect(third) != second
            }
        }
    }
}
