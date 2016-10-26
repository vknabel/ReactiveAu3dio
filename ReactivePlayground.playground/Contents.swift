//: Playground - noun: a place where people can play

import PlaygroundSupport

import RxSwift
import EasyInject
import ValidatedExtension
import ReactiveAu3dio

enum LevelAction: Action {
    case start(Level)

    static let reducer = lensReducer(actionOf: LevelAction.self, currentLevelLens, reducer: { (level: Level?, action: LevelAction) -> Level? in
        switch action {
        case let .start(new) where level == nil:
            return new
        case let .start(new):
            print("Cannot start new level, when another one is running.")
            dump(level, name: "Current Level")
            dump(new, name: "New Level")
            return level
        }
    })
}

let main = Store(
    initial: Observable.just(Ssi()),
    reducers: [
        LevelAction.reducer
    ]
)

let disposable = main.ssio.subscribe()

main.next(LevelAction.start({
    let guinea = Entity().providing("Guinea", for: .entityName)
        .providing(Sound(file: "quiek.mp3", volume: 1.0), for: .entitySound)
        .providing("guinea.png", for: .entityImage)
        .providing(Position(x: 0.3, y: 0.5), for: .entityPosition)
    let level = Level().providing("My Level", for: .levelName)
        .providing("my-background.png", for: .levelBackground)
        .providing([guinea], for: .levelEntities)
    return level
}()))
main.completed()

import AVFoundation

func x(level: Level, entity: Entity) throws -> AVAudioPlayer? {
    guard let viewCenter = LevelWithPosition(value: level)?.position,
        let sound = EntityWithSound(value: entity)?.sound,
        let position = EntityWithPosition(value: entity)?.position,
        let url = Bundle().url(forResource: sound.file, withExtension: sound.fileExtension)
    else {
        return nil
    }
    let player = try AVAudioPlayer(contentsOf: url)
    player.isMeteringEnabled = true
    player.pan = Float(position.horizontalDirection(to: viewCenter))
    player.volume = sound.volume
    return player
}

/*
main.ssio.subscribe(
    onNext: { ssi in

    },
    onError: { error in

    },
    onCompleted: { 

    },
    onDisposed: {

    }
)*/
