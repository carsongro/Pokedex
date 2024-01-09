//
//  PokeListView.swift
//  Pokedex
//
//  Created by Carson Gross on 1/8/24.
//

import SwiftUI
import Kingfisher

struct PokeListView: View {
    @State private var listModel = PokeListModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if listModel.pokemon.isEmpty {
                    ProgressView()
                } else {
                    List {
                        ForEach(listModel.pokemon) { pokemon in
                            NavigationLink(value: pokemon) {
                                HStack {
                                    KFImage(URL(string: pokemon.sprites.front_default ?? ""))
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Text(pokemon.name)
                                }
                            }
                        }
                        
                        paginationIndicator
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Pokédex")
            .navigationDestination(for: Pokemon.self) { pokemon in
                PokeDetailView(pokemon: pokemon)
            }
        }
    }
    
    @ViewBuilder
    var paginationIndicator: some View {
        if listModel.canGetMorePokemon {
            LazyVStack {
                ProgressView()
                    .onAppear {
                        listModel.getMorePokemon()
                    }
            }
        }
    }
}

#Preview {
    PokeListView()
}
