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
    weak var background: UIView! = nil
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

    var leftView: UIView!
    var rightView: UIView!
    func loadTestView(into view: UIView) {
        let (leftView, rightView) = (UIView(), UIView())
        defer {
            view.addSubview(leftView)
            view.addSubview(rightView)
            (self.leftView, self.rightView) = (leftView, rightView)
        }
        
        UIImageView().rx.image
    }
}

PlaygroundPage.current.liveView = ViewController()

import RxLens

extension Store {
    var currentLevel: Observable<Level> {
        return main.ssio.from(currentLevelLens)
            .flatMap{ level -> Observable<Level> in
                guard let nonNil = level else { return Observable.empty() }
                return Observable.of(nonNil)
        }
    }
}

extension Lens where A: Injector {
    static func with<T>(injected provider: Provider<A.Key, T>) -> Lens<A, T?> {
        return Lens<A, T?>(
            from: { (injector: A) -> T? in
                let optional: T? = try? injector.resolving(from: provider)
                return optional
            },
            to: { property, entity in
                if let property = property {
                    return entity.providing(property, for: provider)
                } else {
                    return entity.revoking(for: provider)
                }
            }
        )
    }
}

let entitiesOfLevelLens: Lens<Level, [Entity]?> = .with(injected: .levelEntities)
let imageOfEntityLens: Lens<Entity, String?> = .with(injected: .entityImage)
let nameOfEntityLens: Lens<Entity, String?> = .with(injected: .entityName)
let positionOfEntityLens: Lens<Entity, Position?> = .with(injected: .entityPosition)

func entitiesStream(from source: Observable<Level>) -> Observable<[Entity]> {
    return source.from(entitiesOfLevelLens).map({ $0 ?? [] })
}

extension Lens {
    /// TODO: MOVE INTO RxLens
    func child<C>(from: @escaping (B) -> C, to: @escaping (C, B) -> B) -> Lens<A, C> {
        return Lens<A, C>(
            from: { from(self.from($0)) },
            to: { (c: C, a: A) -> A in
                let b: B = to(c, self.from(a))
                return self.to(b, a) as A
            }
        )
    }

    func asChild<S>(of parent: Lens<S, A>) -> Lens<S, B> {
        return parent.child(from: from, to: to)
    }
}

func combiningPositionWithImageStream<Image>(image: Observable<Image>, position: Observable<Position>) {
    Observable.combineLatest(image, position) { image, position in
        (image, position)
    }
}

func flatten<T>(_ source: Observable<T?>) -> Observable<T> {
    return source.flatMap { optional -> Observable<T> in
        if let v = optional {
            return Observable.of(v)
        } else {
            return Observable.empty()
        }
    }
}

func maybeEqual<T: Equatable>(_ lhs: T?, _ rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case let (.some(lhs), .some(rhs)):
        return lhs == rhs
    default:
        return false
    }
}

struct DisplayEntity {
    let name: String
    let image: String
    let position: Position

    static func from(name: String?, image: String?, position: Position?) -> DisplayEntity? {
        if let name = name, let image = image, let position = position {
            return DisplayEntity(name: name, image: image, position: position)
        } else {
            return nil
        }
    }
}

typealias EntityView = UIImageView

extension DisplayEntity {
    /// Assumes that image will never change for performance reasons
    func apply(to view: EntityView?) -> EntityView? {
        let view = view ?? EntityView(image: UIImage(named: image))
        return view
    }

    static func from(entity: Entity) -> DisplayEntity? {
        guard let name = EntityWithName(value: entity)?.name,
            let image = EntityWithImage(value: entity)?.image,
            let position = EntityWithPosition(value: entity)?.position else {
            return nil
        }
        return DisplayEntity(name: name, image: image, position: position)
    }
}

extension DisplayEntity {
    static func translation(in rootView: UIView) -> ValueToObjectTranslator<String, DisplayEntity, EntityView> {
        return ValueToObjectTranslator<String, DisplayEntity, EntityView>(
            indexOfValue: { $0.name },
            updateObjectWithValue: DisplayEntity.apply,
            performChanges: { changes, translated in
                // TODO: performChanges needs to be refactored and split into smaller chunks 

                func objectsOf(_ set: Set<String>) -> [EntityView] {
                    return set.flatMap { translated[$0]?.object }
                }
                // Update superviews
                objectsOf(changes.removed).forEach { $0.removeFromSuperview() }
                objectsOf(changes.added).forEach { rootView.addSubview($0) }

                // Apply constraints
                for index in changes.current {
                    guard let (value, view) = translated[index] else {
                        fatalError()
                    }
                    func updateConstraint(for coordinate: CGFloat, first firstAttribute: NSLayoutAttribute, second secondAttribute: NSLayoutAttribute) {
                        let constraint = view.constraints.first(where: { constraint in
                            constraint.firstItem === view
                                && constraint.firstAttribute == .centerX
                                && constraint.relation == .equal
                                && constraint.secondItem === rootView
                                && constraint.secondAttribute == .width
                                && constraint.relation == .equal
                                && constraint.constant == 0.0
                        })
                        if constraint?.multiplier != CGFloat(value.position.x) {
                            _ = constraint.map(rootView.removeConstraint)
                            let newConstraint = NSLayoutConstraint(
                                item: view,
                                attribute: NSLayoutAttribute.centerX,
                                relatedBy: NSLayoutRelation.equal,
                                toItem: rootView,
                                attribute: NSLayoutAttribute.width,
                                multiplier: CGFloat(value.position.x),
                                constant: 0.0
                            )
                            NSLayoutConstraint.activate([newConstraint])
                        }
                    }

                    updateConstraint(for: CGFloat(value.position.x), first: .centerX, second: .width)
                    updateConstraint(for: CGFloat(value.position.y), first: .centerY, second: .height)
                    updateConstraint(for: 0.3, first: .width, second: .width)
                    updateConstraint(for: 0.3, first: .height, second: .height)
                }
            }
        )
    }
}

extension Store {
    var currentBackground: Observable<UIImage?> {
        return currentLevel
            .map({ level -> String? in
                guard let background = LevelWithBackground(value: level)?.background else {
                    return nil
                }
                return background
            })
            .distinctUntilChanged(maybeEqual)
            .map({ name in
                if let name = name, let background = UIImage(named: name) {
                    return background
                } else {
                    return nil
                }
            })
    }

    var displayEntities: Observable<[DisplayEntity]> {
        return ssio.from(currentLevelLens).map({ level in
            guard let level = level,
                let entities = entitiesOfLevelLens.from(level) else {
                return []
            }
            return entities.flatMap(DisplayEntity.from(entity:))
        })
    }

    func displayEntities(into view: UIView) -> Observable<Changes<UIImageView>> {
        return DisplayEntity.translation(in: view).execute(with: displayEntities)
    }
}
