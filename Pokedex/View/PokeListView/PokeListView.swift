//
//  PokeListView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import SwiftUI

struct PokeListView: View {
    
    // MARK: Properties
    
    @ObservedObject var viewModel = PokeListViewViewModel()
    @Namespace private var fullscreen
    @State private var selectedPokemon: Pokemon? = nil
    
    @GestureState private var dragGestureOffset = CGSize.zero
    @State private var scrollOffsetY = CGFloat.zero
    
    let standardPadding: CGFloat = 14
    
    // MARK: Body
    
    var body: some View {
        GeometryReader { fullView in
            ZStack {
                ScrollViewReader { value in
                    ScrollView {
                        ForEach(viewModel.pokemon) { pokemon in
                            if selectedPokemon == nil || selectedPokemon?.id ?? 0 == (pokemon.id + 1) { // We need to get rid of many of the pokemon for performance reasons
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
                                    .frame(height: fullView.size.height * 0.1)
                                    .onTapGesture {
                                        withAnimation(.openDetailView) {
                                            selectedPokemon = pokemon
                                            value.scrollTo(pokemon.id, anchor: .top)
                                        }
                                    }
                                }
                                .brightness(selectedPokemon == nil ? 0 : -0.3)
                            } else {
                                Color.clear
                                    .frame(height: fullView.size.height * 0.1)
                            }
                        }
                        .padding(.horizontal, standardPadding)
                        
                        progressView
                    }
                    .scrollDisabled(selectedPokemon != nil)
                }
                pokeDetailView
                
            }
            .coordinateSpace(name: "fullView")
            .background {
                Color(uiColor: .secondarySystemBackground)
                    .ignoresSafeArea()
                    .brightness(selectedPokemon == nil ? 0 : -0.3)
            }
        }
    }
    
    // MARK: Private Methods
    
    private func dismissPokemon() {
        withAnimation(.closeDetailView) { 
            self.selectedPokemon = nil
        }
    }
    
    private func getDetailViewPadding(topSafeArea: CGFloat) -> CGFloat {
        guard scrollOffsetY > 0 else {
            return standardPadding // Draggin down to dismiss
        }
        
        guard scrollOffsetY < topSafeArea else {
            return 0 // Scrolling through the detail view, this stops it from getting bigger
        }
        
        return standardPadding - (scrollOffsetY / topSafeArea) * standardPadding
    }
}

// MARK: Views

extension PokeListView {
    
    @ViewBuilder
    var pokeDetailView: some View {
        if let selectedPokemon = selectedPokemon {
            GeometryReader { innerDetail in
                ScrollView(.vertical, showsIndicators: scrollOffsetY >= innerDetail.safeAreaInsets.top) {
                    PokeDetailView(viewModel: .init(pokemon: selectedPokemon), namespace: fullscreen) {
                        dismissPokemon()
                    }
                    .id(selectedPokemon.id)
                    .padding(.horizontal, getDetailViewPadding(topSafeArea: innerDetail.safeAreaInsets.top))
                    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offsetY in
                        if offsetY <= -85 {
                            dismissPokemon()
                        }
                        if scrollOffsetY <= -85 && offsetY > scrollOffsetY {
                            dismissPokemon()
                        }
                        scrollOffsetY = offsetY
                    }
                }
                .coordinateSpace(name: "scroll")
            }
        }
    }
    
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
