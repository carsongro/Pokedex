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
            return .gray
        case .fire:
            return .red
        case .water:
            return .blue
        case .grass:
            return .green
        case .electric:
            return .yellow
        case .ice:
            return .teal
        case .fighting:
            return .red
        case .poison:
            return .purple
        case .ground:
            return .brown
        case .flying:
            return .mint
        case .psychic:
            return .pink
        case .bug:
            return .green
        case .rock:
            return .gray
        case .ghost:
            return .purple
        case .dragon:
            return .purple
        case .dark:
            return .brown
        case .steel:
            return .gray
        case .fairy:
            return .pink
        }
    }
}
