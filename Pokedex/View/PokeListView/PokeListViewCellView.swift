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
    var namespace: Namespace.ID
    
    @State private var showFullscreen = false
    
    var body: some View {
        GeometryReader { geo in
            RelativeHStack {
                Text(String(viewModel.id))
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 22, weight: .regular, design: .monospaced))
                    .layoutPriority(1)
                    .matchedGeometryEffect(id: String(viewModel.id), in: namespace)
                
                KFAnimatedImage(viewModel.pokemonAnimatedSpriteURL != nil ? viewModel.pokemonAnimatedSpriteURL : viewModel.pokemonSpriteURL)
                    .scaledToFit()
                    .shadow(color: .secondary, radius: 2, x: 1, y: -1)
                    .layoutPriority(1)
                    .matchedGeometryEffect(id: viewModel.pokemonSpriteURL?.absoluteString, in: namespace)
                    .frame(width: geo.frame(in: .global).height * 2/3, height: geo.frame(in: .global).height * 2/3)
                
                
                Text(viewModel.pokemonName)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .lineLimit(1) //TODO: Handle this better
                    .layoutPriority(3)
                    .matchedGeometryEffect(id: viewModel.pokemonName, in: namespace)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct PokeListViewCellView_Previews: PreviewProvider {
    @Namespace static var simulator
    
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
                    ),
            namespace: simulator
        )
        .frame(width: 350, height: 100)
    }
}
