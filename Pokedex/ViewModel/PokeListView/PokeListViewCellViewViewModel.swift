//
//  PokeListViewCellViewViewModel.swift
//  Pokedex
//
//  Created by Carson Gross on 9/10/23.
//

import SwiftUI

@MainActor
final class PokeListViewCellViewViewModel: ObservableObject {
    @Published var pokemonSprite: UIImage?
    let pokemonName: String
    let pokemonAnimatedSpriteURL: URL?
    let pokemonSpriteURL: URL?
    
    // MARK: Init
    
    init(
        pokemonName: String,
        pokemonSpriteURL: URL?,
        pokemonAnimatedSpriteURL: URL?
    ) {
        self.pokemonName = pokemonName
        self.pokemonSpriteURL = pokemonSpriteURL
        self.pokemonAnimatedSpriteURL = pokemonAnimatedSpriteURL
    }
}
