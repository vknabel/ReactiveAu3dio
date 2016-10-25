//
//  Level.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import EasyInject

public extension Provider {
    public static var levelName: Provider<LevelField, String> {
        return .derive()
    }
    public static var levelGoals: Provider<LevelField, [Goal]> {
        return .derive()
    }
    public static var levelBackground: Provider<LevelField, String> {
        return .derive()
    }
    public static var levelEntities: Provider<LevelField, [Entity]> {
        return .derive()
    }
    public static var levelAmbients: Provider<LevelField, [Sound]> {
        return .derive()
    }
}
