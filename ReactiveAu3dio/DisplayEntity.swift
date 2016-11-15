//
//  DisplayEntity.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 15.11.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public struct DisplayEntity {
    public let name: String
    public let image: String
    public let position: Position

    public init(name: String, image: String, position: Position) {
        self.name = name
        self.image = image
        self.position = position
    }

    public static func from(name: String?, image: String?, position: Position?) -> DisplayEntity? {
        if let name = name, let image = image, let position = position {
            return DisplayEntity(name: name, image: image, position: position)
        } else {
            return nil
        }
    }
}
