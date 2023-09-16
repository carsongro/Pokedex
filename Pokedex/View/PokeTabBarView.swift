//
//  PokeTabBarView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import SwiftUI

struct PokeTabBarView: View {
    var body: some View {
        NavigationStack {
            TabView {
                Group {
                    PokeListView()
                        .tabItem {
                            Image(systemName: "house")
                        }
                    
                    PokeSearchView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }
                }
                .toolbarBackground(.thinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
        }
    }
}

struct PokeTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        PokeTabBarView()
    }
}
