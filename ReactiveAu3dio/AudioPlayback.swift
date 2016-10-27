//
//  AudioPlayback.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 27.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxSwift
import AVFoundation

public struct Changes<V: Hashable> {
    public let current: Set<V>
    public let removed: Set<V>
    public let added: Set<V>

    public init() {
        self.init(current: [], removed: [], added: [])
    }

    private init(current: Set<V>, removed: Set<V>, added: Set<V>) {
        self.current = current
        self.removed = removed
        self.added = added
    }

    public init(previous: Set<V>, next: Set<V>) {
        self.init(
            current: next,
            removed: previous.subtracting(next),
            added: next.subtracting(previous)
        )
    }
}

public func player(audioEntities: Observable<[AudioEntity]>) -> Observable<[URL: AVAudioPlayer]> {
    return audioEntities.scan([URL: AVAudioPlayer]()) { previous, audioEntities in
        var next = [URL: AVAudioPlayer]()
        for audio in audioEntities {
            next[audio.url] = try? audio.apply(to: previous[audio.url])
        }
        return next
    }
}

public func playerChanges(players: Observable<[URL: AVAudioPlayer]>) -> Observable<Changes<AVAudioPlayer>> {
    return players.scan(Changes()) { changes, next in
        return Changes(previous: changes.current, next: Set(next.values))
    }
}

public func apply(playbackChanges: Changes<AVAudioPlayer>) {
    playbackChanges.removed.map(AVAudioPlayer.stop).forEach({ $0() })
    playbackChanges.added.map(AVAudioPlayer.play).forEach({ _ = $0() })
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
        return playerChanges(players: player(audioEntities: levelAudios))
            .do(onNext: apply(playbackChanges:))
    }
}
