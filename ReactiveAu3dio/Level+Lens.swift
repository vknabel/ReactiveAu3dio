//
//  Level+Lens.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 15.11.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxLens

public let entitiesOfLevelLens: Lens<Level, [Entity]?> = .with(injected: .levelEntities)
public let positionOfLevelLens: Lens<Level, Position?> = .with(injected: .levelPosition)
