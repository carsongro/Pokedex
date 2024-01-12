//
//  PokemonType.swift
//  Pokedex
//
//  Created by Carson Gross on 9/11/23.
//

import SwiftUI

enum PokemonType: String, Codable {
    case normal
    case fire
    case water
    case grass
    case electric
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
    
    public var color: Color {
        switch self {
        case .normal:
            return Color("Normal")
        case .fire:
            return Color("Fire")
        case .water:
            return Color("Water")
        case .grass:
            return Color("Grass")
        case .electric:
            return Color("Electric")
        case .ice:
            return Color("Ice")
        case .fighting:
            return Color("Fighting")
        case .poison:
            return Color("Poison")
        case .ground:
            return Color("Ground")
        case .flying:
            return Color("Flying")
        case .psychic:
            return Color("Psychic")
        case .bug:
            return Color("Bug")
        case .rock:
            return Color("Rock")
        case .ghost:
            return Color("Ghost")
        case .dragon:
            return Color("Dragon")
        case .dark:
            return Color("Dark")
        case .steel:
            return Color("Steel")
        case .fairy:
            return Color("Fairy")
        }
    }
}
