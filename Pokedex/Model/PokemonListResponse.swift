//
//  PokemonListResponse.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import Foundation

struct PokeGetAllPokemonResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokeGetAllPokemonResponseResult]
}

struct PokeGetAllPokemonResponseResult: Codable {
    let name: String
    let url: String
}

