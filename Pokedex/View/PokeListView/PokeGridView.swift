//
//  PokeGridView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import SwiftUI

struct PokeGridView: View {
    @ObservedObject var viewModel = PokeListViewViewModel()
    
    private var gridLayout = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout) {
                ForEach(viewModel.pokemon) { pokemon in
                    PokeGridViewCellView(
                        viewModel:
                                .init(
                                    id: pokemon.id,
                                    pokemonName: pokemon.name.firstLetterCapitalized(),
                                    pokemonSpriteURL: URL(string: pokemon.sprites.front_default ?? ""),
                                    pokemonAnimatedSpriteURL: URL(string: pokemon.sprites.versions.generationV.blackWhite.animated?.front_default ?? "")
                                )
                    )
                    .shadow(color: .secondary, radius: 3, x: 2, y: 2)
                    .frame(width: UIScreen.main.bounds.width - 25)
                }
                
                if viewModel.canGetMorePokemon {
                    ProgressView()
                        .padding(.top, 20)
                        .onAppear { viewModel.getMorePokemon() }
                }
            }
        }
    }
}

struct PokeGridView_Previews: PreviewProvider {
    static var previews: some View {
        PokeGridView()
    }
}
