//
//  Model.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 13.01.17.
//  Copyright © 2017 Valentin Knabel. All rights reserved.
//

import EasyInject

protocol GenerateInjector { }

/// sourcery: name = "ssi", skipTypedef
enum SsiDeclaration: GenerateInjector {
    /// sourcery: type = "[Scenario]"
    case scenarios
    /// sourcery: type = "Level"
    case currentLevel
}

/// sourcery: name = "scenario"
enum ScenarioDeclaration: GenerateInjector {
    /// sourcery: type = "String"
    case name
}

/// sourcery: name = "level"
enum LevelDeclaration: GenerateInjector {
    /// sourcery: type = "String"
    case name
    /// sourcery: type = "[Goal]"
    case goals
    /// sourcery: type = "String"
    case background
    /// sourcery: type = "[Entity]"
    case entities
    /// sourcery: type = "[Sound]"
    case ambients
    /// sourcery: type = "Position"
    case position
}

/// sourcery: name = "entity"
enum EntityDeclaration: GenerateInjector {
    /// sourcery: type = "String"
    case name
    /// sourcery: type = "String"
    case image
    /// sourcery: type = "Sound"
    case sound
    /// sourcery: type = "Position"
    case position
}

/// sourcery: name = "goal"
enum GoalDeclaration: GenerateInjector {
    /// sourcery: type = "String"
    case name
}
