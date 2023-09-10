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
        List(viewModel.pokemon) { pokemon in
            VStack {
                Text(pokemon.name)
            }
        }
    }
}

struct PokeListView_Previews: PreviewProvider {
    static var previews: some View {
        PokeListView()
    }
}
