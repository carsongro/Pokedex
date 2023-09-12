//
//  PokeListView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import SwiftUI

struct PokeListView: View {
    @ObservedObject var viewModel = PokeListViewViewModel()
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(viewModel.pokemon) { pokemon in
                        PokeListViewCellView(
                            viewModel:
                                    .init(
                                        id: pokemon.id,
                                        pokemonName: pokemon.name.firstLetterCapitalized(),
                                        pokemonSpriteURL: URL(string: pokemon.sprites.front_default ?? ""),
                                        pokemonAnimatedSpriteURL: URL(string: pokemon.sprites.versions.generationV.blackWhite.animated?.front_default ?? ""),
                                        types: pokemon.types
                                    )
                        )
                        .shadow(color: .secondary, radius: 2, x: 2, y: 2)
                        .frame(height: fullView.size.height * 0.1)
                    }
                    
                    if viewModel.canGetMorePokemon {
                        ProgressView()
                            .padding(.top, 20)
                            .onAppear { viewModel.getMorePokemon() }
                    }
                }
                .padding(12)
            }
        }
    }
}

struct PokeListView_Previews: PreviewProvider {
    static var previews: some View {
        PokeListView()
    }
}
