//: Playground - noun: a place where people can play

import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift
import EasyInject
import ValidatedExtension
import ReactiveAu3dio

//: Set up all Actions

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

//: Set up the store (all reducers must be included)

let main = Store(
    initial: Observable.just(Ssi()),
    reducers: [
        LevelAction.reducer
    ]
)

//: Display view

import UIKit
import RxCocoa


final class ViewController: UIViewController {
    weak var slider: UISlider! = nil
    /// Will be disposed when view controller will be deallocated
    let bag = DisposeBag()

    override func viewDidLoad() {
        // Start audio playback
        main.levelAudioPlayback
            .subscribe(onCompleted: { PlaygroundPage.current.finishExecution() })
            .addDisposableTo(bag)

        // bind slider to position of player
        slider.rx.value.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                main.next(LevelAction.turnTo(value))
            })
            .addDisposableTo(bag)

        // Load default data
        // Won't be required in actual app
        main.next(LevelAction.start({
            let guinea = Entity().providing("Guinea", for: .entityName)
                .providing(Sound(file: "quiek", fileExtension: "mp3", volume: 0.5), for: .entitySound)
                .providing("guinea.png", for: .entityImage)
                .providing(Position(x: 0.5, y: 0.5), for: .entityPosition)
            let level = Level().providing("My Level", for: .levelName)
                .providing("my-background.png", for: .levelBackground)
                .providing([guinea], for: .levelEntities)
                .providing(Position(x: 0.25, y: 0.5), for: .levelPosition)
                .providing([Sound(file: "rain-light", fileExtension: "mp3", volume: 1.0)], for: .levelAmbients)
            return level
            }())
        )
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = UIColor.white

        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        view.addSubview(slider)
        self.slider = slider

        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0)
        ])

        self.view = view
    }
}

PlaygroundPage.current.liveView = ViewController()
