//
//  PokeGridViewCellView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/10/23.
//

import SwiftUI
import Kingfisher

struct PokeGridViewCellView: View {
    @ObservedObject var viewModel: PokeListViewCellViewViewModel
    
    var body: some View {
        VStack {
            KFAnimatedImage(viewModel.pokemonAnimatedSpriteURL)
                .scaledToFit()
                .shadow(radius: 5, x: 5, y: -5)
                    
            Text(viewModel.pokemonName)
        }
        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
}

struct PokeGridViewCellView_Previews: PreviewProvider {
    static var previews: some View {
        PokeGridViewCellView(
            viewModel:
                    .init(
                        pokemonName: "Dewott",
                        pokemonSpriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/502.png"),
                        pokemonAnimatedSpriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/502.gif")
                    )
        )
    }
}
