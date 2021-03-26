//
//  Chest.swift
//  projet-3
//
//  Created by Valc0d3 on 15/01/2021.
//

import Foundation

struct ChestDataSource {

    let weapons: [Weapon]

    static func loadWeapons() -> ChestDataSource {
        let superSword = Weapon(type: .superSword(.damage(15)))
        let superAxe = Weapon(type: .superAxe(.damage(16)))
        let superBow = Weapon(type: .superBow(.damage(14)))
        let superStick = Weapon(type: .superStick(.heal(17)))
        let weapons = [
            superSword,
            superAxe,
            superBow,
            superStick
        ]
        return .init(weapons: weapons)
    }
}

struct Chest {
    
    // MARK: - Properties
    
    private let weapons: [Weapon]
    
    //MARK: - Init
    
    init(dataSource: ChestDataSource) {
        self.weapons = dataSource.weapons
    }

    func generateRandomWeapon() -> Weapon? {
        let index = Int.random(in: 0..<weapons.count)
        return weapons[index]
    }
}
