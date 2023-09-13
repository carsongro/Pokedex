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
        GeometryReader { geo in
            RelativeHStack {
                Text(String(viewModel.id))
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 22, weight: .regular, design: .monospaced))
                    .layoutPriority(1)
                
                KFAnimatedImage(viewModel.pokemonAnimatedSpriteURL != nil ?
                        viewModel.pokemonAnimatedSpriteURL :
                            viewModel.pokemonSpriteURL
                )
                .scaledToFit()
                .frame(width: geo.frame(in: .global).height * 2/3, height: geo.frame(in: .global).height * 2/3)
                .shadow(color: .secondary, radius: 2, x: 1, y: -1)
                .layoutPriority(1)
                
                
                Text(viewModel.pokemonName)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .lineLimit(1) //TODO: Handle this better
                    .layoutPriority(3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(.regularMaterial)
//            .background {
//                    PokemonType(rawValue: viewModel.types.first?.type.name ?? "normal")?.color
//            }
            .cornerRadius(10)
            .shadow(color: .secondary, radius: 1, x: 2, y: 2)
        }
    }
}

struct PokeListViewCellView_Previews: PreviewProvider {
    static var previews: some View {
        PokeListViewCellView(
            viewModel:
                    .init(
                        id: 5020,
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
        .frame(width: 350, height: 125)
    }
}
