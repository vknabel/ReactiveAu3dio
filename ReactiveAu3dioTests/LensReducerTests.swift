//
//  LensReducerTests.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 24.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxSwift
import EasyInject
import ValidatedExtension
@testable import ReactiveAu3dio
import RxBlocking
import RxTest

import Quick
import Nimble

fileprivate enum OneAction: Action {
    case one
}
fileprivate enum OtherAction: Action {
    case other
}

fileprivate struct HasName: Validator {
    fileprivate static func validate(_ value: Ssi) throws -> Bool {
        return value.providedKeys.contains("name")
    }
}

final class LensReducerTests: QuickSpec {
    override func spec() {
    }
}
