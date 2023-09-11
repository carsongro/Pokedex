//
//  PokeTabBarView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import SwiftUI

struct PokeTabBarView: View {
    var body: some View {
        TabView {
            PokeGridView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            PokeSearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
        }
    }
}

struct PokeTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        PokeTabBarView()
    }
}
