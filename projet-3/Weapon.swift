//
//  Weapon.swift
//  projet-3
//
//  Created by Valc0d3 on 15/01/2021.
//

import Foundation

enum ActionType: Equatable {
    case damage(Int)
    case heal(Int)
}

enum WeaponType {
    case sword(ActionType)
    case axe(ActionType)
    case bow(ActionType)
    case superSword(ActionType)
    case superAxe(ActionType)
    case superBow(ActionType)
    case stick(ActionType)
    case superStick(ActionType)
}

struct Weapon {
    let name: String
    let action: ActionType
    let type: WeaponType

    init(type: WeaponType) {
        self.type = type
        switch type {
        case .sword(let action):
            self.name = "sword"
            self.action = action
        case .axe(let action):
            self.name = "axe"
            self.action = action
        case .bow(let action):
            self.name = "bow"
            self.action = action
        case .superSword(let action):
            self.name = "superSword"
            self.action = action
        case .superAxe(let action):
            self.name = "superAxe"
            self.action = action
        case .superBow(let action):
            self.name = "superBow"
            self.action = action
        case .stick(let action):
            self.name = "stick"
            self.action = action
        case .superStick(let action):
            self.name = "superStick"
            self.action = action
        }
    }
}
