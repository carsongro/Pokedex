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
        List {
            Section {
                KFAnimatedImage(URL(string: pokemon.sprites.versions.generationV.blackWhite.animated?.front_default ?? ""))
                    .frame(width: 200, height: 200)
            }
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity)
            
            Section {
                Text(pokemon.name.firstLetterCapitalized())
                    .font(.title)
                    .fontWeight(.semibold)
            }
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity)
        }
        .listStyle(.plain)
    }
}

#Preview {
    PokeDetailView(pokemon: previewPokemon)
}
