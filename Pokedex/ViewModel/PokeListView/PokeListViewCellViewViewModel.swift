//
//  PokeListViewCellViewViewModel.swift
//  Pokedex
//
//  Created by Carson Gross on 9/10/23.
//

import SwiftUI
import Kingfisher

@MainActor
final class PokeListViewCellViewViewModel: ObservableObject {
    @Published var spriteImageColor: Color = .secondary
    let pokemonName: String
    let pokemonAnimatedSpriteURL: URL?
    let pokemonSpriteURL: URL?
    let id: Int
    let types: [PokemonResponseType]
    
    // MARK: Init
    
    init(
        id: Int,
        pokemonName: String,
        pokemonSpriteURL: URL?,
        pokemonAnimatedSpriteURL: URL?,
        types: [PokemonResponseType]
    ) {
        self.id = id
        self.pokemonName = pokemonName
        self.pokemonSpriteURL = pokemonSpriteURL
        self.pokemonAnimatedSpriteURL = pokemonAnimatedSpriteURL
        self.types = types
        getColorFromImage()
    }
    
    // MARK: Private
    
    private func getColorFromImage() {
        guard let url = pokemonSpriteURL else { return }
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            switch result {
            case .success(let image):
                guard let color = image.image.cgImage?.color else { return }
                
                DispatchQueue.main.async {
                    self?.spriteImageColor = color
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
