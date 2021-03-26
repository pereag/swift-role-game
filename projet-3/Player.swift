//
//  Player.swift
//  projet-3
//
//  Created by Valc0d3 on 15/01/2021.
//

import Foundation

final class Player {

    // MARK: - Properties

    let name: String
    var lose: Bool = false
    private(set) var team: [Character] = []
    
    // MARK: - Init

    init(name: String, team: [Character]) {
        self.name = name
        self.team = team
    }

    // MARK: - Public
    func removeCharacter(character: Character) {
        guard let index = team.firstIndex(where: { $0 == character }) else { return }
        team.remove(at: index)
    }
    
    
}
