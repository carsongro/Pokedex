//
//  PokemonRowView.swift
//  Pokedex
//
//  Created by Carson Gross on 1/10/24.
//

import SwiftUI
import Kingfisher

struct PokemonRowView: View {
    var pokemon: Pokemon
    
    var body: some View {
        HStack {
            Text(String(format: "%04d", pokemon.id))
            
            KFImage(URL(string: pokemon.sprites.front_default ?? ""))
                .resizable()
                .frame(width: 70, height: 70)
                .aspectRatio(contentMode: .fit)
                .accessibilityHidden(true)
            
            Text(pokemon.name.firstLetterCapitalized())
                .lineLimit(1)
                .fontWeight(.semibold)
            
            Spacer()
            
            VStack {
                ForEach(pokemon.types, id: \.type.name) { type in
                    PokemonTypeBubble(type: type)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PokemonRowView(pokemon: previewPokemon)
}
