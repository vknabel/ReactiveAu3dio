//: Playground - noun: a place where people can play

import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift
import EasyInject
import ValidatedExtension
import ReactiveAu3dio

enum LevelAction: Action {
    case start(Level)
    case moveTo(Position)
    case turnTo(Position.Coordinate)

    static let reducer = lensReducer(actionOf: LevelAction.self, currentLevelLens, reducer: { (level: Level?, action: LevelAction) -> Level? in
        switch action {
        case let .start(new) where level == nil:
            return new
        case let .start(new):
            print("Cannot start new level, when another one is running.")
            dump(level, name: "Current Level")
            dump(new, name: "New Level")
            return level
        case let .moveTo(newCenter):
            guard let level = level else { return nil }
            return level.providing(newCenter, for: .levelPosition)
        case let .turnTo(coordinate):
            guard let someLevel = level,
                var position = LevelWithPosition(value: someLevel)?.position
            else {
                return level
            }
            position.x = coordinate
            return someLevel.providing(position, for: .levelPosition)
        }
    })
}

let main = Store(
    initial: Observable.just(Ssi()),
    reducers: [
        LevelAction.reducer
    ]
)

//let disposable = main.ssio.subscribe()

import AVFoundation

var players = [URL: AVAudioPlayer]()
let levelAudio = main.ssio.subscribe(
    onNext: { ssi in
        guard let currentLevel = SsiWithCurrentLevel(value: ssi)?.currentLevel else { return }
        let audioEntities = AudioEntity.fromLevel(level: currentLevel)
        var nextPlayers = [URL: AVAudioPlayer]()
        for audio in audioEntities {
            nextPlayers[audio.url] = try? audio.apply(to: players[audio.url])
        }
        let nextURLs = Set(nextPlayers.keys)
        let previousURLs = Set(players.keys)

        for removedKey in previousURLs.subtracting(nextURLs) {
            players[removedKey]?.stop()
        }

        for addedKey in nextURLs.subtracting(previousURLs) {
            nextPlayers[addedKey]?.play()
        }

        players = nextPlayers
    },
    onError: { error in

    },
    onCompleted: { 
        for (_, p) in players {
            p.stop()
        }
        players = [:]

        PlaygroundPage.current.finishExecution()
    },
    onDisposed: {

    }
)

main.next(LevelAction.start({
    let guinea = Entity().providing("Guinea", for: .entityName)
        .providing(Sound(file: "quiek", fileExtension: "mp3", volume: 1.0), for: .entitySound)
        .providing("guinea.png", for: .entityImage)
        .providing(Position(x: 0.5, y: 0.5), for: .entityPosition)
    let level = Level().providing("My Level", for: .levelName)
        .providing("my-background.png", for: .levelBackground)
        .providing([guinea], for: .levelEntities)
        .providing(Position(x: 0.25, y: 0.5), for: .levelPosition)
    return level
    }())
)

Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
    main.next(LevelAction.turnTo(0.375))
}
Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
    main.next(LevelAction.turnTo(0.5))
}
Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
    main.next(LevelAction.turnTo(0.625))
}
Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
    main.next(LevelAction.turnTo(0.75))
}
Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
    main.completed()
}
