//
//  PokeDetailViewViewModel.swift
//  Pokedex
//
//  Created by Carson Gross on 9/13/23.
//

import Foundation
 
@MainActor
final class PokeDetailViewViewModel: ObservableObject {
    var pokemon: Pokemon
    
    var pokemonName: String {
        pokemon.name
    }
    
    var pokemonAnimatedSpriteURL: URL? {
        URL(string: pokemon.sprites.versions.generationV.blackWhite.animated?.front_default ?? "")
    }
    
    var pokemonSpriteURL: URL? {
        URL(string: pokemon.sprites.front_default ?? "")
    }
    
    var id: Int {
        pokemon.id
    }
    init(
        pokemon: Pokemon
    ) {
        self.pokemon = pokemon
    }
}
