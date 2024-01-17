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
                KFAnimatedImage(URL(string: animatedSpriteURLString))
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
            
            Section {
                typeBubbles
            } header: {
                Text("Type")
                    .frame(maxWidth: .infinity)
            }
            .listRowSeparator(.hidden)
            
            Section {
                
            } header: {
                Text("Abilities")
                    .frame(maxWidth: .infinity)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    private var typeBubbles: some View {
        HStack {
            ForEach(pokemon.types, id: \.type.name) { type in
                PokemonTypeBubble(type: type)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
    }
    
    private var animatedSpriteURLString: String { pokemon.sprites.versions.generationV.blackWhite.animated?.front_default ?? ""
    }
}

#Preview {
    PokeDetailView(pokemon: previewPokemon)
}
