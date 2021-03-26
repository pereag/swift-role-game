//
//  Game.swift
//  projet-3
//
//  Created by Valc0d3 on 15/01/2021.
//

import Foundation

final class Game {

    // MARK: - Properties

    private var players: [Player] = []
    private var usedNames: [String] = []
    private var characterNbrByTeam = 3
    private var playerActionCount: Double = 0
    // verifications properties
 

    // MARK: - Public

    func start() {
        setting()
        play()
        endGame()
    }

    // MARK: - Private
    
    private func setting() {
        print("Configuration de la partie:")
        setPlayersNames()
    }

    private func setPlayersNames() {
        for i in 1...2 {
            print("Nom du joueur ", i)
            let name = createName()
            let team = createTeam()
            let player = Player(name: name, team: team)
            players.append(player)
        }
    }

    func createTeam() -> [Character] {
        var team: [Character] = []
        for a in 1...characterNbrByTeam {
            print("Creation du character n°\(a)")
            let character = createCharacter(team: team)
            team.append(character)
        }
        return team
    }
    
    private func createCharacter(team:[Character]) -> Character {
        var character: Character!
        repeat {
            let name = createName()
            let type = createType(team: team)
            let _character = Character(name: name, type: type)
            character = _character
        } while character == nil
        return character
    }

    private func createName() -> String {
        var name: String!
        var counter = 0
        repeat {
            if counter > 0 {
                print("Vous avez mal saisi le nom ou ce nom existe déja pris")
            }
            if let _name = readLine(), !_name.isEmpty, !_name.trimmingCharacters(in: .whitespaces).isEmpty, !usedNames.contains(_name) {
                name = _name
                usedNames.append(name)
            }
            counter+=1
        } while name == nil
        return name
    }
    
    func createType(team:[Character]) -> CharacterType {
        var type: CharacterType!
        var counter = 0
        print("Type du personnage:")
        repeat {
            if counter > 0 {
                print("Vous avez mal saisi le nom du type, ou vous avez essayé d'ajouter un soigneur alors que vous n'avez pas d'attaquant dans votre équipe.")
            }
            if let _nameOfType = readLine(), !_nameOfType.isEmpty, !_nameOfType.trimmingCharacters(in: .whitespaces).isEmpty, let _type = CharacterType(rawValue: _nameOfType) {
                let healersArray:[Character] = team.filter {$0.type.rawValue == "human"}
                if (_type == CharacterType(rawValue: "human") && team.count > healersArray.count) || (_type !=  CharacterType(rawValue: "human")){
                    type = _type
                }
            }
            counter+=1
        } while type == nil
        return type
    }
    
    // Start party
    private func play() {
        print("Super, la partie peut commencer !")
        print("Deux groupe de guerrier courageux ce retrouvent face à face pour un combat mémorable...")
        round()
    }
    private func enumeCharactersStat(player: Player) {
        for a in player.team {
            print(a.name,"est un", a.type,", il a", a.weapon.name,"comme équipement et il lui reste", a.life,"PV.")
        }
    }
    func verifIfCharacterExist(TeamOfCharacterTargeted: [String]) -> String {
        var allyTarget: String!
        var counter = 0
        repeat {
            if counter != 0 {
                print("Ce personnage n'existe pas")
            }
            if let _allyTarget = readLine(), !_allyTarget.isEmpty, !_allyTarget.trimmingCharacters(in: .whitespaces).isEmpty, TeamOfCharacterTargeted.contains(_allyTarget) {
                allyTarget = _allyTarget
            }
            counter+=1
        } while allyTarget == nil
        return allyTarget
    }
    
    private func returnCharacterObject(teamNameArray: [String],  player: Player, charactereName: String) -> Character {
        let currentCharacterNbr: Int! = teamNameArray.firstIndex(of: charactereName)
        let currentCharacter = player.team[currentCharacterNbr]
        return currentCharacter
    }
    private func round(){
        var thereIsMoreThanOneTeamWithOneAliveNonHealerCharacter: Bool = true
        repeat {
            let attacker = players[0]
            let defender = players[1]
            var teamAllyNames: [String] = []
            var teamEnemyNames: [String] = []
            playerActionCount+=1
            
            for a in attacker.team {
                teamAllyNames.append(a.name)
            }
            for a in defender.team {
                teamEnemyNames.append(a.name)
            }
            
            // Player 1 selects a character in his team
            print("Au tour du joueur", attacker.name, "de commencer.")
            print("votre équipe:")
            enumeCharactersStat(player: attacker)
            print("Aliée sélectionné:")
            let allyTargetName = verifIfCharacterExist(TeamOfCharacterTargeted: teamAllyNames)
            let currentCharacter = returnCharacterObject(teamNameArray: teamAllyNames,  player: attacker, charactereName: allyTargetName)
            
            // Player 1 heals or attacks a target depending on their equipment
            if currentCharacter.type.rawValue == "human" {
                print("Choisissez un aliée à soigner:")
                enumeCharactersStat(player: attacker)
                let allyHealedSelectedName = verifIfCharacterExist(TeamOfCharacterTargeted: teamAllyNames)
                let allyHealedSelected = returnCharacterObject(teamNameArray: teamAllyNames,  player: attacker, charactereName: allyHealedSelectedName)
                allyHealedSelected.updateLife(with: currentCharacter.weapon.action)
                print(currentCharacter.name,"soigne", allyHealedSelected.name,", il a maitenant", allyHealedSelected.life, "PV.")
                
            } else {
                print("Choisissez un ennemie à attaquer:")
                enumeCharactersStat(player: defender)
                let enemieTargetedName = verifIfCharacterExist(TeamOfCharacterTargeted: teamEnemyNames)
                let enemieTargeted = returnCharacterObject(teamNameArray: teamEnemyNames,  player: defender, charactereName: enemieTargetedName)
                enemieTargeted.updateLife(with: currentCharacter.weapon.action)
                print(currentCharacter.name,"attaque",enemieTargeted.name,". Il lui reste", enemieTargeted.life,"pv.")
                if enemieTargeted.isAlive == false {
                    defender.removeCharacter(character: enemieTargeted)
                    print(enemieTargeted.name, "est mort !")
                    let defenderHealer = defender.team.filter {$0.type.rawValue == "human"}
                    print(defenderHealer)
                    if defender.team.count == 0 || defenderHealer.count == defender.team.count {
                        thereIsMoreThanOneTeamWithOneAliveNonHealerCharacter = false
                        defender.lose = true
                    }
                }
            }
             // A magic chest is coming
            if let chest = generateRandomChest() {
                guard let weapon = chest.generateRandomWeapon() else { return }
                if (((weapon.name == "superStick") && (currentCharacter.type.rawValue == "human")) || ((weapon.name != "superStick") && (currentCharacter.type.rawValue != "human"))) {
                    currentCharacter.updateWeapon(lastWeapon: weapon)
                    print("Bravo",currentCharacter.name,"a gagnié \(weapon.name)")
                } else if ((weapon.name == "superStick") && (currentCharacter.type.rawValue != "human") || (weapon.name != "superStick") && (currentCharacter.type.rawValue == "human")) {
                    print(currentCharacter.name,"a gagné \(weapon.name), mais ne sait pas comment s'en servir. Il préfere utiliser son équipement actuel.")
                }
            }
            players.swapAt(0, 1)
        } while thereIsMoreThanOneTeamWithOneAliveNonHealerCharacter == true
        print("partie terminée")
    }
    
    private func generateRandomChest() -> Chest? {
        let getLucky = Int.random(in: 1..<10)
        if getLucky <= 2 {
            let chest = Chest(dataSource: .loadWeapons())
            return chest
        } else {
            return nil
        }
        
    }

    private func endGame() {
        print("La partie à durée", ceil(self.playerActionCount/2),"tours.")
        for player in players {
            if player.lose == false {
                print("Bravo", player.name, "Vous avez gagné !")
                print("L'équipe gagnante:")
                enumeCharactersStat(player: player)
            } else if player.lose && player.team.count <= 0 {
                print("L'équipe de", player.name, "A été pulvérisé, Il ne reste aucun survivant !")
            } else if player.lose && player.team.count > 0 {
                print("L'équipe de", player.name, "a perdu. Les soigneurs de l'équipe ont fui.")
                print("Survivants de l'équipe perdante:")
                enumeCharactersStat(player: player)
            }
        }
    }
}
