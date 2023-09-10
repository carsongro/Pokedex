//
//  PokeListViewViewModel.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import Foundation

final class PokeListViewViewModel: ObservableObject {
    @Published var pokemon = [Pokemon]()
    
    init() {
        fetchInitialPokemon()
    }
    
    func fetchInitialPokemon() {
        let request = PokeRequest(endpoint: .pokemon)
        Task {
            do {
                let result = try await PokeService.shared.execute(request, expecting: PokeGetAllPokemonResponse.self)
                guard let firstPokemonURL = URL(string: result.results.first?.url ?? ""),
                      let firstPokemonResultRequest = PokeRequest(url: firstPokemonURL)else {
                    return
                }
                
                let firstPokeResult = try await PokeService.shared.execute(firstPokemonResultRequest, expecting: Pokemon.self)
                Task { @MainActor in
                    pokemon.append(firstPokeResult)
                }
            } catch {
                print(error)
            }
        }
    }
}
