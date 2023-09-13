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
                        .frame(height: fullView.size.height * 0.1)
                        .padding(3)
                    }
                }
                .padding(12)
                
                progressView
            }
        }
    }
}

extension PokeListView {
    var progressView: some View {
        LazyVStack { // VStack needs to be lazy in order to only paginate when needed
            // Keep this outside of the VGrid so that on large devices
            // with multiple columns, the spinner is in the right spot
            if viewModel.canGetMorePokemon {
                ProgressView()
                    .padding(.top, 20)
                    .onAppear { viewModel.getMorePokemon() }
            }
        }
    }
}

struct PokeListView_Previews: PreviewProvider {
    static var previews: some View {
        PokeListView()
    }
}
