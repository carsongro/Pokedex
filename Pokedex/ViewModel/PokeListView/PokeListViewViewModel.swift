//
//  PokeListViewViewModel.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import SwiftUI

@MainActor
final class PokeListViewViewModel: ObservableObject {
    @Published var pokemon = [Pokemon]()
    var canGetMorePokemon: Bool {
        nextURL != nil
    }
    
    private var nextURL: String?
    private var isLoadingMorePokemon = false
    
    // MARK: Init
    
    init() {
        fetchInitialPokemon()
    }
    
    // MARK: Public
    
    public func getMorePokemon() {
        guard let urlString = nextURL,
              let url = URL(string: urlString) else {
            return
        }
        
        fetchAdditionalPokemon(url: url)
    }
    
    // MARK: Private
    
    /// Gets all Pokémon, this takes forever and blocks the main thread so not good to use for use as of now
    private func fetchAllPokemon() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let request = PokeRequest(
                    endpoint: .pokemon,
                    queryParameters: [
                        URLQueryItem(
                            name: "limit",
                            value: "100000"
                        ),
                        URLQueryItem(
                            name: "offset",
                            value: "0"
                        )
                    ]
                )
                
                let result = try await PokeService.shared.execute(request, expecting: PokeGetAllPokemonResponse.self)
                let newPokemon = try await getPokemonFromAllPokemonResponse(allPokemonResult: result)
                updatePokemon(with: newPokemon, animated: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchInitialPokemon() {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let newPokemon = try await getInitialNewPokemon()
                updatePokemon(with: newPokemon, animated: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Function that gets the initial list of pokemon
    /// - Returns: An array of pokemon
    private func getInitialNewPokemon() async throws -> [Pokemon] {
        let request = PokeRequest(
            endpoint: .pokemon,
            queryParameters: [
                URLQueryItem(
                    name: "limit",
                    value: "200"
                ),
                URLQueryItem(
                    name: "offset",
                    value: "0"
                )
            ]
        )
        let allPokemonResult = try await PokeService.shared.execute(request, expecting: PokeGetAllPokemonResponse.self)
        nextURL = allPokemonResult.next
        
        return try await getPokemonFromAllPokemonResponse(allPokemonResult: allPokemonResult)
    }
    
    /// Coverts the result of getting all pokemon into an array of pokemon
    /// - Parameter allPokemonResult: PokeGetAllPokemonResponse to get the pokemon from
    /// - Parameter filterAlternates: A bool that lets us
    /// - Returns: Array of pokemon
    private func getPokemonFromAllPokemonResponse(allPokemonResult: PokeGetAllPokemonResponse, filterAlternates: Bool = false) async throws -> [Pokemon] {
        return try await withThrowingTaskGroup(of: Pokemon?.self) { group in
            var newPokemon = [Pokemon]()

            for result in allPokemonResult.results {
                guard let url = URL(string: result.url),
                      let pokemonRequest = PokeRequest(url: url) else {
                    continue
                }

                group.addTask {
                    /// Adding a do catch block here so that the throw doesn't propegate up and cancel the whole task
                    /// This way it only affects this iteration of the for loop
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
                if loadedPokemon.id > 10_000 && filterAlternates { // Any pokemon over 10,000 is an alternate form so we can choose to not include them
                    nextURL = nil // So we set the nextURL to nil so that we don't get any more
                    continue
                }
                newPokemon.append(loadedPokemon)
            }

            /// Task Groups return based on completions not in order they are stored
            /// So sorting is needed here
            return newPokemon.sorted { $0.id < $1.id }
        }
    }
    
    /// Get more pokemon and add them to the array of Pokémon
    /// - Parameter url: The url for the next page of Pokémon
    private func fetchAdditionalPokemon(url: URL) {
        guard !isLoadingMorePokemon else {
            return
        }
        isLoadingMorePokemon = true
        
        Task { [weak self] in
            guard let self,
                  let request = PokeRequest(url: url) else {
                return
            }
            
            do {
                let result = try await PokeService.shared.execute(request, expecting: PokeGetAllPokemonResponse.self)
                nextURL = result.next
                
                let newPokemon = try await getPokemonFromAllPokemonResponse(allPokemonResult: result, filterAlternates: true)
                updatePokemon(with: newPokemon, animated: true)
                isLoadingMorePokemon = false
            } catch {
                isLoadingMorePokemon = false
                print(error.localizedDescription)
            }
        }
    }
    
    /// Add new Pokémon to the pokemon array
    /// - Parameter newPokemon: The new Pokémon to add
    private func updatePokemon(with newPokemon: [Pokemon], animated: Bool = false) {
        // On main thread
        withAnimation(animated ? .default : .none) {
            pokemon.append(contentsOf: newPokemon)
        }
    }
}
