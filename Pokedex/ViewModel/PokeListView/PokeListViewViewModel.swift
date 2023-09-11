//
//  PokeListViewViewModel.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import Foundation

@MainActor
final class PokeListViewViewModel: ObservableObject {
    @Published var pokemon = [Pokemon]()
    
    // MARK: Init
    
    init() {
        fetchInitialPokemon()
    }
    
    // MARK: Private
    
    private func fetchInitialPokemon() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let newPokemon = try await self.getInitialNewPokemon()
                self.updatePokemon(with: newPokemon)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Function that gets the initial list of pokemon
    /// - Returns: An array of pokemon
    private func getInitialNewPokemon() async throws -> [Pokemon] {
        let request = PokeRequest(endpoint: .pokemon)
        let allPokemonResult = try await PokeService.shared.execute(request, expecting: PokeGetAllPokemonResponse.self)
        
//        var newPokemon = [Pokemon]()
//        for result in allPokemonResult.results {
//            guard let url = URL(string: result.url),
//                  let pokemonRequest = PokeRequest(url: url) else {
//                continue
//            }
//
//            let newPokemonResult = try await PokeService.shared.execute(pokemonRequest, expecting: Pokemon.self)
//            newPokemon.append(newPokemonResult)
//        }
//        await self.updatePokemon(with: newPokemon)
//        return []
        
        return try await withThrowingTaskGroup(of: Pokemon?.self) { group in
            var newPokemon = [Pokemon]()

            for result in allPokemonResult.results {
                guard let url = URL(string: result.url),
                      let pokemonRequest = PokeRequest(url: url) else {
                    continue
                }

                group.addTask {
                    /// Adding a do catch block here so that the throw doesn't propegate up and cancel the whole task
                    do {
                        return try await PokeService.shared.execute(pokemonRequest, expecting: Pokemon.self)
                    } catch {
                        print(error)
                        return nil
                    }
                }
            }

            for try await loadedPokemon in group {
                guard let loadedPokemon = loadedPokemon else { continue }
                newPokemon.append(loadedPokemon)
            }

            return newPokemon.sorted { $0.id < $1.id }
        }
    }
    
    private func updatePokemon(with newPokemon: [Pokemon]) {
        // On main thread
        pokemon.append(contentsOf: newPokemon)
    }
}
