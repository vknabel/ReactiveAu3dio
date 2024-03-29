//
//  AudioPlayback.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 27.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxSwift
import AVFoundation

public extension AudioEntity {
    public static var translation: ValueToObjectTranslator<URL, AudioEntity, AVAudioPlayer> {
        return ValueToObjectTranslator<URL, AudioEntity, AVAudioPlayer>(
            indexOfValue: { $0.url },
            updateObjectWithValue: AudioEntity.apply,
            commitChanges: { playbackChanges in
                playbackChanges.removed.map(AVAudioPlayer.stop).forEach({ $0() })
                playbackChanges.added.map(AVAudioPlayer.play).forEach({ _ = $0() })
            }
        )
    }
}

extension Store {
    public var entityAudios: Observable<[AudioEntity]> {
        return ssio.map { ssi -> [AudioEntity] in
            guard let currentLevel = SsiWithCurrentLevel(value: ssi)?.currentLevel else { return [AudioEntity]() }
            return AudioEntity.fromLevel(level: currentLevel)
        }
    }

    public var ambientAudios: Observable<[AudioEntity]> {
        return ssio.map { ssi -> [AudioEntity] in
            guard let currentLevel = SsiWithCurrentLevel(value: ssi)?.currentLevel,
                let ambients = LevelWithAmbients(value: currentLevel)?.ambients
                else { return [AudioEntity]() }
            return ambients.flatMap(AudioEntity.fromAmbient)
        }
    }

    public var levelAudios: Observable<[AudioEntity]> {
        return Observable.zip(entityAudios, ambientAudios) { entities, ambients -> [AudioEntity] in
            var entities = entities
            entities.append(contentsOf: ambients)
            return entities
        }
    }

    public var levelAudioPlayback: Observable<Changes<AVAudioPlayer>> {
        var currentPlayers: Set<AVAudioPlayer> = []
        func stopRemainingPlayers() {
            currentPlayers.forEach { $0.stop() }
            currentPlayers = []
        }
        return AudioEntity.translation.execute(with: levelAudios)
            .do(
                onNext: { currentPlayers = $0.current },
                onCompleted: stopRemainingPlayers,
                onDispose: stopRemainingPlayers
        )
    }
}
