//
//  Character.swift
//  projet-3
//
//  Created by Valc0d3 on 15/01/2021.
//

import Foundation

enum CharacterType: String, CaseIterable {
    case dwarf = "dwarf"
    case orc = "orc"
    case human = "human"
    case elf = "elf"
}

final class Character: Equatable {

    let name: String
    private(set) var weapon: Weapon
    let type: CharacterType
    var isAlive: Bool {
        return life > 0
    }
    
    private(set) var life: Int
    private(set) var maxLife: Int

    init(name: String, type: CharacterType) {
        self.name = name
        self.type = type
        switch type {
        case .dwarf:
            self.life = 100
            self.weapon = Weapon(type: .sword(.damage(12)))
        case .elf:
            self.life = 120
            self.weapon = Weapon(type: .bow(.damage(9)))
        case .human:
            self.life = 100
            self.weapon = Weapon(type: .stick(.heal(10)))
        case .orc:
            self.life = 80
            self.weapon = Weapon(type: .axe(.damage(13)))
        }
        self.maxLife = life
    }

    public static func ==(lhs: Character, rhs: Character) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }

    func updateLife(with action: ActionType) {
        switch action {
        case .damage(let value):
            decreaseLife(with: value)
        case .heal(let value):
            increaseLife(with: value)
        }
    }

    private func decreaseLife(with value: Int) {
        if value > life {
            life = 0
        } else {
            life -= value
        }
    }
     
    private func increaseLife(with value: Int) {
        if (value + life) > maxLife {
            life = maxLife
        } else {
            life += value
        }
    }
    
    func updateWeapon(lastWeapon: Weapon) {
        self.weapon = lastWeapon
    }
}
