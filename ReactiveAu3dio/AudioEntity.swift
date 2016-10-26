//
//  AudioEntity.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 26.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import AVFoundation

public struct AudioEntity {
    public let url: URL
    public let pan: Float
    public let volume: Float

    public static func fromLevel(level: Level) -> [AudioEntity] {
        guard let viewCenter = LevelWithPosition(value: level)?.position,
            let entities = LevelWithEntities(value: level)
            else {
                return []
        }
        return entities.entities.flatMap(AudioEntity.fromEntity(viewCenter: viewCenter))
    }

    public static func fromEntity(viewCenter: Position) -> (Entity) -> AudioEntity? {
        return { entity in
            guard let sound = EntityWithSound(value: entity)?.sound,
                let position = EntityWithPosition(value: entity)?.position
                else {
                    return nil
            }
            guard let url = Bundle.main.url(forResource: sound.file, withExtension: sound.fileExtension) else {
                debugPrint("WARNING: cannot find:", sound.file, sound.fileExtension ?? "with any extension")
                return nil
            }
            return AudioEntity(
                url: url,
                pan: position.horizontalDirection(to: viewCenter),
                volume: sound.volume
            )
        }
    }

    public func apply(to player: AVAudioPlayer?) throws -> AVAudioPlayer {
        let player = try player ?? AVAudioPlayer(contentsOf: url)
        player.isMeteringEnabled = true
        player.pan = pan
        player.volume = volume
        return player
    }
}
