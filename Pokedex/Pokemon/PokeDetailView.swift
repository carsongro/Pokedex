//
//  PokeDetailView.swift
//  Pokedex
//
//  Created by Carson Gross on 1/8/24.
//

import SwiftUI
import Kingfisher

struct PokeDetailView: View {
    var pokemon: Pokemon
    
    var body: some View {
        Text(pokemon.name)
    }
}

#Preview {
    PokeDetailView(pokemon: previewPokemon)
}
