//
//  AudioEntity.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 26.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

@testable import ReactiveAu3dio

import Quick
import Nimble
import AVFoundation

final class AudioEntityTests: QuickSpec {
    override func spec() {
        describe("audio entities") {
            it("can be initialized") {
                let audio = AudioEntity(url: URL(string: "file:///")!, pan: 2.0, volume: 1.0)
                expect(audio.url) == URL(string: "file:///")!
                expect(audio.pan) == 2.0
                expect(audio.volume) == 1.0
            }

            // Needs some mocks and bundled files

            /*
            it("can be initialized from an entity") {
                let entity = Entity().providing("Guinea", for: .entityName)
                    .providing(Sound(file: "quiek", fileExtension: "mp3", volume: 1.0), for: .entitySound)
                    .providing("guinea.png", for: .entityImage)
                    .providing(Position(x: 0.5, y: 0.5), for: .entityPosition)
                let audio = AudioEntity.fromEntity(viewCenter: Position(x: 0.0, y: 0.0))(entity)
                expect(audio).toNot(beNil())
            }

            it("can be initialized from a level") {

            }*/

            /*it("can applied to audio players") {
                let audio = AudioEntity(url: URL(string: "file:///")!, pan: 2.0, volume: 1.0)
                let player = try! audio.apply(to: AVAudioPlayer())
                expect(player.url) == audio.url
                expect(player.pan) == audio.pan
                expect(player.volume) == audio.volume
            }*/

            it("creates audio players when none is given") {
                let audio = AudioEntity(url: URL(string: "file:///")!, pan: 2.0, volume: 1.0)
                expect(audio.apply(to: nil)).to(beNil())
            }
        }
    }
}
