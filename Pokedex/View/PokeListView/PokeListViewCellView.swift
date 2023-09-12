//
//  PokeListViewCellView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/10/23.
//

import SwiftUI
import Kingfisher

struct PokeListViewCellView: View {
    @ObservedObject var viewModel: PokeListViewCellViewViewModel
    
    var body: some View {
        VStack {
            KFAnimatedImage(viewModel.pokemonAnimatedSpriteURL != nil ?
                            viewModel.pokemonAnimatedSpriteURL :
                                viewModel.pokemonSpriteURL
            )
            .scaledToFit()
            .shadow(color: .secondary, radius: 3, x: 2, y: -2)
            
            HStack {
                Text("\(viewModel.id)")
                Text(viewModel.pokemonName)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(10)
    }
}

struct PokeListViewCellView_Previews: PreviewProvider {
    static var previews: some View {
        PokeListViewCellView(
            viewModel:
                    .init(
                        id: 502,
                        pokemonName: "Dewott",
                        pokemonSpriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/502.png"),
                        pokemonAnimatedSpriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/502.gif"),
                        types: [
                            PokemonResponseType(
                                slot: 0,
                                type: Species(
                                    name: "water",
                                    url: ""
                                )
                            )
                        ]
                    )
        )
    }
}
