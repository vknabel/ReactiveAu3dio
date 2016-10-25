//
//  Sound.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public struct Sound: Equatable {
    public let file: String
    public let volume: Float

    public init(file: String, volume: Float) {
        self.file = file
        self.volume = volume
    }

    public static func == (lhs: Sound, rhs: Sound) -> Bool {
        return lhs.file == rhs.file && lhs.volume == rhs.volume
    }
}
