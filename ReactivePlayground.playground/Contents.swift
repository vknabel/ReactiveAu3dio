//: Playground - noun: a place where people can play

import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift
import EasyInject
import ValidatedExtension
import ReactiveAu3dio
import RxLens

// TODO: REMOVE

extension DisplayEntity {
    public static func translation(into rootView: UIView) -> ValueToObjectTranslator<String, DisplayEntity, EntityView> {
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
                    func updateConstraint(with constant: CGFloat, first firstAttribute: NSLayoutAttribute, second secondAttribute: NSLayoutAttribute,
                                          other root: UIView?,
                                          multiplier: CGFloat = 1.0
                        ) {
                        let isSameConstraint = { (constraint: NSLayoutConstraint) -> Bool in
                            return constraint.firstItem === view
                                && constraint.firstAttribute == firstAttribute
                                && constraint.relation == .equal
                                && constraint.secondItem === root
                                && constraint.secondAttribute == secondAttribute
                                && constraint.relation == .equal
                        }
                        var constraint = view.constraints.first(where: isSameConstraint)
                        if case .none = constraint, let root = root {
                            constraint = root.constraints.first(where: isSameConstraint)
                        }
                        if constraint?.multiplier != .some(multiplier) {
                            _ = constraint.map {
                                root?.removeConstraint($0)
                            }
                            let newConstraint = NSLayoutConstraint(
                                item: view,
                                attribute: firstAttribute,
                                relatedBy: NSLayoutRelation.equal,
                                toItem: root,
                                attribute: secondAttribute,
                                multiplier: multiplier,
                                constant: constant
                            )
                            NSLayoutConstraint.activate([newConstraint])
                        } else if constraint?.constant != .some(constant) {
                            constraint?.constant = constant
                        }
                    }

                    let maxWidth = rootView.bounds.size.width - rootView.bounds.origin.x
                    let maxHeight = rootView.bounds.size.height - rootView.bounds.origin.y
                    updateConstraint(
                        with: CGFloat(value.position.x) * maxWidth,
                        first: .centerX,
                        second: .leading,
                        other: rootView
                    )
                    updateConstraint(
                        with: CGFloat(value.position.y) * maxHeight,
                        first: .centerY,
                        second: .top,
                        other: rootView
                    )

                    let imageHeight = (view.image?.size.height ?? 1)
                    let imageWidth = (view.image?.size.width ?? 1)
                    let ratio = imageHeight / maxHeight
                    let height = 0.3 * ratio * maxHeight
                    let width = height * imageWidth / imageHeight
                    updateConstraint(
                        with: height,
                        first: .height,
                        second: .notAnAttribute,
                        other: nil,
                        multiplier: 1.0
                    )

                    updateConstraint(
                        with: width,
                        first: .width,
                        second: .notAnAttribute,
                        other: nil,
                        multiplier: 1.0
                    )
                }
            }
        )
    }
}

private typealias ViewConstraintTriplet = (view: UIView, centerX: NSLayoutConstraint, centerY: NSLayoutConstraint)
private extension Store {
    func displayPosition(into rootView: UIView) -> Observable<UIView> {
        return ssio.from(currentLevelLens).scan(nil, accumulator: { (previous: ViewConstraintTriplet?, currentLevel: Level?) in
                guard let currentLevel = currentLevel, let position = LevelWithPosition(value: currentLevel)?.position else {
                    return previous
                }
            let maxWidth = rootView.bounds.size.width - rootView.bounds.origin.x
            let maxHeight = rootView.bounds.size.height - rootView.bounds.origin.y
            
            let current: (view: UIView, centerX: NSLayoutConstraint, centerY: NSLayoutConstraint)
            if let previous = previous {
                current = previous
            } else {
                current = {
                    let displayedView = UIView()
                    displayedView.backgroundColor = .red
                    displayedView.translatesAutoresizingMaskIntoConstraints = false
                    rootView.addSubview(displayedView)
                    
                    let centerX = NSLayoutConstraint(
                        item: displayedView,
                        attribute: .centerX,
                        relatedBy: .equal,
                        toItem: rootView,
                        attribute: .leading,
                        multiplier: 1.0,
                        constant: 0.5 * maxWidth
                    )
                    let centerY = NSLayoutConstraint(
                        item: displayedView,
                        attribute: .centerY,
                        relatedBy: .equal,
                        toItem: rootView,
                        attribute: .top,
                        multiplier: 1.0,
                        constant: 0.5 * maxHeight
                    )
                    NSLayoutConstraint.activate([
                        centerX,
                        centerY,
                        displayedView.widthAnchor.constraint(equalToConstant: 10),
                        displayedView.heightAnchor.constraint(equalToConstant: 10)
                    ])
                    return (displayedView, centerX, centerY)
                }()
            }
            
            current.centerX.constant = CGFloat(position.x) * maxWidth
            current.centerY.constant = CGFloat(position.y) * maxHeight
            return current
        })
        .flatMap({ (triple: ViewConstraintTriplet?) -> Observable<UIView> in
            if let view = triple?.view {
                return .of(view)
            } else {
                return .empty()
            }
        });
    }
}

public extension Store {
    public var currentBackground: Observable<UIImage?> {
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

    public var displayEntities: Observable<[DisplayEntity]> {
        return ssio.from(currentLevelLens).map({ level in
            guard let level = level,
                let entities = entitiesOfLevelLens.from(level) else {
                    return []
            }
            return entities.flatMap(DisplayEntity.from(entity:))
        })
    }

    public func displayEntities(into view: UIView) -> Observable<Changes<EntityView>> {
        return DisplayEntity.translation(into: view)
            .execute(with: displayEntities)
    }
    
    /*func displayView(into view: UIView) -> Observable<Void> {
        return
    }*/
}

// REMOVE

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
public extension Observable {
    public static func from(optional elements: E?) -> Observable {
        return Observable.from(elements)
    }
    
    public static func from(_ elements: E?...) -> Observable {
        return Observable.from(elements.flatMap({ $0 }))
    }
}
final class ViewController: UIViewController {
    weak var slider: UISlider! = nil
    weak var left: UIView! = nil
    weak var right: UIView! = nil
    /// Will be disposed when view controller will be deallocated
    var bag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        // Start audio playback
        main.levelAudioPlayback
            .subscribe(onCompleted: { PlaygroundPage.current.finishExecution() })
            .addDisposableTo(bag)

        main.displayEntities(into: left)
            .subscribe()
            .addDisposableTo(bag)
        main.displayEntities(into: right)
            .subscribe()
            .addDisposableTo(bag)
        
        main.displayPosition(into: view)
            .subscribe()
            .addDisposableTo(bag)
        
        main.currentLevel.from(positionOfLevelLens)
            .scan((false, nil), accumulator: { previous, next -> (Bool, Position?) in
                guard let previous = previous.1?.x, let current = next?.x, abs(previous - current) > 0.5 else {
                    return (false, next)
                }
                switch (previous, current) {
                case (0..<0.5, 0.5...1.0):
                    return (true, next)
                case (0.5...1.0, 0..<0.5):
                    return (true, next)
                default:
                    return (false, next)
                }
            })
            .filter({ $0.0 })
            .flatMap({ Observable.from(optional: $0.1?.x) })
            .subscribe(onNext: { [weak self] xCoordinate in
                if xCoordinate < 0.5 {
                    print("Right")
                    self?.left.backgroundColor = .lightGray
                    self?.right.backgroundColor = .gray
                } else {
                    print("Left")
                    self?.left.backgroundColor = .gray
                    self?.right.backgroundColor = .lightGray
                }
            })
            .addDisposableTo(bag)

        // bind slider to position of player
        main.currentLevel.from(positionOfLevelLens)
            .flatMap(Observable.from(optional:))
            .single()
            .subscribe(onNext: { [weak self] in self?.slider.value = $0.x })
            .addDisposableTo(bag)
        
        slider.rx.value.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                main.next(LevelAction.turnTo(value))
            })
            .addDisposableTo(bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bag = DisposeBag()
    }

    var seeded = false
    override func viewDidLayoutSubviews() {
        guard !seeded else { return }
        seeded = true
        // Load default data
        // Won't be required in actual app
        main.next(LevelAction.start({
            let guinea = Entity().providing("Guinea", for: .entityName)
                .providing(Sound(file: "quiek", fileExtension: "mp3", volume: 0.5), for: .entitySound)
                .providing("guinea.png", for: .entityImage)
                .providing(Position(x: 0.3, y: 0.9), for: .entityPosition)
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
        slider.maximumValue = 2.0
        view.addSubview(slider)
        self.slider = slider

        slider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0)
        ])

        let left = UIView()
        left.backgroundColor = .gray
        view.addSubview(left)
        self.left = left

        let right = UIView()
        right.backgroundColor = .lightGray
        view.addSubview(right)
        self.right = right
        
        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            left.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 8.0),
            left.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            left.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            left.trailingAnchor.constraint(equalTo: right.leadingAnchor),
            left.widthAnchor.constraint(equalTo: right.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            right.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 8.0),
            right.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            right.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        self.view = view
    }
}

PlaygroundPage.current.liveView = ViewController()
