//
//  PokemonTypeBubble.swift
//  Pokedex
//
//  Created by Carson Gross on 1/16/24.
//

import SwiftUI

struct PokemonTypeBubble: View {
    var type: PokemonResponseType
    
    var body: some View {
        if let color = PokemonType(rawValue: type.type.name)?.color{
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(color)
                .overlay {
                    Text(type.type.name.firstLetterCapitalized())
                }
                .frame(maxWidth: 100)
        }
    }
}

#Preview {
    PokemonTypeBubble(type: PokemonResponseType(slot: 0, type: Species(name: "", url: "")))
}
