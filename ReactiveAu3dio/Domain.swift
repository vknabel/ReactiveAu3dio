//
//  Domain.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import EasyInject

// MARK: Scenario

public enum ScenarioFieldKey { }
public typealias ScenarioField = GenericProvidableKey<ScenarioFieldKey>
public typealias Scenario = StrictInjector<ScenarioField>
public typealias ScenarioProvider<v> = Provider<ScenarioField, v>

// MARK: Level

public enum LevelFieldKey { }
public typealias LevelField = GenericProvidableKey<LevelFieldKey>
public typealias Level = StrictInjector<LevelField>
public typealias LevelProvider<v> = Provider<LevelField, v>

// MARK: Entities

public enum EntityFieldKey { }
public typealias EntityField = GenericProvidableKey<EntityFieldKey>
public typealias Entity = StrictInjector<EntityField>
public typealias EntityProvider<v> = Provider<EntityField, v>

// MARK: Goal

public enum GoalFieldKey { }
public typealias GoalField = GenericProvidableKey<GoalFieldKey>
public typealias Goal = StrictInjector<GoalField>
public typealias GoalProvider<v> = Provider<GoalField, v>
