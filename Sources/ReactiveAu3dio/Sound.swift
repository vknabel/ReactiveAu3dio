//
//  Sound.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 25.10.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

public struct Sound: Equatable {
    public let file: String
    public let fileExtension: String?
    public let volume: Float

    public init(file: String, fileExtension: String? = nil, volume: Float = 1.0) {
        self.file = file
        self.fileExtension = fileExtension
        self.volume = volume
    }

    public static func == (lhs: Sound, rhs: Sound) -> Bool {
        return lhs.file == rhs.file && lhs.fileExtension == rhs.fileExtension && lhs.volume == rhs.volume
    }
}
