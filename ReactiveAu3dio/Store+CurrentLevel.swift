//
//  Store+CurrentLevel.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 13.01.17.
//  Copyright © 2017 Valentin Knabel. All rights reserved.
//

import Foundation
import RxSwift

public extension Store {
    public var currentLevel: Observable<Level> {
        return self.ssio.from(currentLevelOfSsiLens)
            .flatMap { level -> Observable<Level> in
                guard let nonNil = level else { return Observable.empty() }
                return Observable.of(nonNil)
        }
    }
}
