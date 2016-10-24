//: Playground - noun: a place where people can play

import PlaygroundSupport

import RxSwift
import EasyInject
import ValidatedExtension
import ReactiveAu3dio
import RxBlocking

let initialStream = Observable.just(Ssi().providing([], for: .scenarios))

let main = Store(
    initial: initialStream,
    reducers: [CounterAction.reducer, CounterAction.logger]
)

let disposable = main.ssio.subscribe()

main.next(CounterAction.increase)
main.next(CounterAction.increase)
main.next(CounterAction.decrease)
main.next(ScenarioAction.append(Scenario().providing("My Scene", for: .scenarioName)))
main.completed()
