//
//  PokeListView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import SwiftUI

struct PokeListView: View {
    @ObservedObject var viewModel = PokeListViewViewModel()
    @Namespace private var fullscreen
    @State private var selectedPokemon: Pokemon? = nil
    
    var body: some View {
        GeometryReader { fullView in
            ScrollViewReader { value in
                ScrollView {
                    ForEach(viewModel.pokemon) { pokemon in
                        if selectedPokemon?.id != pokemon.id {
                            LazyVStack {
                                PokeListViewCellView(
                                    viewModel:.init(
                                        id: pokemon.id,
                                        pokemonName: pokemon.name.firstLetterCapitalized(),
                                        pokemonSpriteURL: URL(string: pokemon.sprites.front_default ?? ""),
                                        pokemonAnimatedSpriteURL: URL(string: pokemon.sprites.versions.generationV.blackWhite.animated?.front_default ?? ""),
                                        types: pokemon.types
                                    ),
                                    namespace: fullscreen
                                )
                                .id(pokemon.id)
                                .frame(minHeight: fullView.size.height * 0.1)
                                .background {
                                    backgroundView
                                        .matchedGeometryEffect(id: String(pokemon.id) + "background", in: fullscreen)
                                }
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedPokemon = pokemon
                                        value.scrollTo(pokemon.id, anchor: .top)
                                    }
                                }
                            }
                        } else if let selectedPokemon = selectedPokemon {
                            PokeDetailView(
                                viewModel: .init(pokemon: selectedPokemon),
                                namespace: fullscreen
                            )
                            .id(pokemon.id)
                            .background {
                                backgroundView
                                    .matchedGeometryEffect(id: String(selectedPokemon.id) + "background", in: fullscreen)
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    self.selectedPokemon = nil
                                }
                            }
                            .frame(height: fullView.size.height * 0.95)
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    progressView
                }
            }
        }
    }
}

extension PokeListView {
    var progressView: some View {
        LazyVStack { // VStack needs to be lazy in order to only paginate when needed
            if viewModel.canGetMorePokemon {
                ProgressView()
                    .padding(.top, 20)
                    .onAppear { viewModel.getMorePokemon() }
            }
        }
    }
    
    var backgroundView: some View {
        Color.clear
            .background(.thinMaterial)
            .cornerRadius(10)
            .shadow(color: .secondary, radius: 1, x: 2, y: 2)
    }
}

struct PokeListView_Previews: PreviewProvider {
    static var previews: some View {
        PokeListView()
    }
}

/// This is an alternate version with a slightly different animation
/// Rather than pushing the elements of the list out of the way
/// It pops up and layers above everything else
//struct PokeListView: View {
//    @ObservedObject var viewModel = PokeListViewViewModel()
//    @Namespace private var fullscreen
//    @State private var selectedPokemon: Pokemon? = nil
//
//    var body: some View {
//        GeometryReader { fullView in
//            ScrollViewReader { value in
//                ScrollView {
//                    ForEach(viewModel.pokemon) { pokemon in
//                        if selectedPokemon?.id != pokemon.id {
//                            PokeListViewCellView(
//                                viewModel: .init(
//                                            id: pokemon.id,
//                                            pokemonName: pokemon.name.firstLetterCapitalized(),
//                                            pokemonSpriteURL: URL(string: pokemon.sprites.front_default ?? ""),
//                                            pokemonAnimatedSpriteURL: URL(string: pokemon.sprites.versions.generationV.blackWhite.animated?.front_default ?? ""),
//                                            types: pokemon.types
//                                        ),
//                                namespace: fullscreen
//                            )
//                            .frame(minHeight: fullView.size.height * 0.1)
//                            .background {
//                                Color.clear
//                                    .background(.thinMaterial)
//                                    .cornerRadius(10)
//                                    .shadow(color: .secondary, radius: 1, x: 2, y: 2)
//                                    .matchedGeometryEffect(id: String(pokemon.id) + "background", in: fullscreen)
//                            }
//                            .onTapGesture {
//                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                                    selectedPokemon = pokemon
//                                }
//                            }
//                        } else {
//                            Color.clear
//                                .frame(minHeight: fullView.size.height * 0.1)
//                        }
//                    }
//                    .opacity(selectedPokemon == nil ? 1 : 0)
//                    .disabled(selectedPokemon != nil)
//
//                    .padding(.horizontal, 12)
//
//                    progressView
//                }
//            }
//
//            if let selectedPokemon = selectedPokemon {
//                PokeDetailView(
//                    viewModel: .init(pokemon: selectedPokemon),
//                    namespace: fullscreen
//                )
//                .background {
//                    Color.clear
//                        .background(.thinMaterial)
//                        .cornerRadius(10)
//                        .shadow(color: .secondary, radius: 1, x: 2, y: 2)
//                        .matchedGeometryEffect(id: String(selectedPokemon.id) + "background", in: fullscreen)
//                }
//                .onTapGesture {
//                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                        self.selectedPokemon = nil
//                    }
//                }
//                .padding(12)
//            }
//        }
//    }
//}
