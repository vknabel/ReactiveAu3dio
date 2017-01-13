//
//  AudioEntity.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 26.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import AVFoundation

public struct AudioEntity: Hashable {
    public let url: URL
    public let pan: Float
    public let volume: Float

    private static func url(for sound: Sound) -> URL? {
        return Bundle.main.url(forResource: sound.file, withExtension: sound.fileExtension)
    }

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
                let position = EntityWithPosition(value: entity)?.position,
                let url = url(for: sound)
                else {
                    return nil
            }
            return AudioEntity(
                url: url,
                pan: position.horizontalDirection(to: viewCenter),
                volume: sound.volume
            )
        }
    }

    public static func fromAmbient(sound: Sound) -> AudioEntity? {
        guard let url = url(for: sound) else {
            return nil
        }
        return AudioEntity(url: url, pan: 0.0, volume: sound.volume)
    }

    public func apply(to player: AVAudioPlayer?) -> AVAudioPlayer? {
        guard let player = try? (player ?? AVAudioPlayer(contentsOf: url)) else {
            return nil
        }
        player.pan = pan
        player.volume = volume
        player.numberOfLoops = -1
        return player
    }

    public var hashValue: Int {
        return url.hashValue + pan.hashValue + volume.hashValue
    }

    public static func == (lhs: AudioEntity, rhs: AudioEntity) -> Bool {
        return lhs.pan == rhs.pan && lhs.url == rhs.url && lhs.volume == rhs.volume
    }
}
