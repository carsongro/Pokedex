//
//  PokeListViewCellViewViewModel.swift
//  Pokedex
//
//  Created by Carson Gross on 9/10/23.
//

import SwiftUI

struct PokeListViewCellViewViewModel {
    let pokemonName: String
    let pokemonAnimatedSpriteURL: URL?
    let pokemonSpriteURL: URL?
    let id: Int
    
    // MARK: Init
    
    init(
        id: Int,
        pokemonName: String,
        pokemonSpriteURL: URL?,
        pokemonAnimatedSpriteURL: URL?
    ) {
        self.id = id
        self.pokemonName = pokemonName
        self.pokemonSpriteURL = pokemonSpriteURL
        self.pokemonAnimatedSpriteURL = pokemonAnimatedSpriteURL
    }
}
