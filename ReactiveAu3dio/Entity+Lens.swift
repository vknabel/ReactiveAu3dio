//
//  Entity+Lens.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 15.11.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import RxLens

public let imageOfEntityLens: Lens<Entity, String?> = .with(injected: .entityImage)
public let nameOfEntityLens: Lens<Entity, String?> = .with(injected: .entityName)
public let positionOfEntityLens: Lens<Entity, Position?> = .with(injected: .entityPosition)
