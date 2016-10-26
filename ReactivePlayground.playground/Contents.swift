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
    let level = Level().providing("My Level", for: .levelName)
        .providing("my-background.png", for: .levelBackground)
        .providing([guinea], for: .levelEntities)
    return level
}()))
main.completed()
