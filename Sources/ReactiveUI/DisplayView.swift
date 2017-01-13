//
//  DisplayView.swift
//  ReactiveAu3dio
//
//  Created by Valentin Knabel on 15.11.16.
//  Copyright © 2016 Valentin Knabel. All rights reserved.
//

import UIKit

public typealias EntityView = UIImageView

public extension DisplayEntity {
    /// Assumes that image will never change for performance reasons
    public func apply(to view: EntityView?) -> EntityView? {
        let view = view ?? EntityView(image: UIImage(named: image))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    public static func from(entity: Entity) -> DisplayEntity? {
        guard let name = EntityWithName(value: entity)?.name,
            let image = EntityWithImage(value: entity)?.image,
            let position = EntityWithPosition(value: entity)?.position else {
                return nil
        }
        return DisplayEntity(name: name, image: image, position: position)
    }
}
