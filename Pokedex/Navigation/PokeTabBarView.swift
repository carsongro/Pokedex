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
            Group {
                PokeListView()
                    .tabItem {
                        Image(systemName: "house")
                    }
            }
        }
    }
}

struct PokeTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        PokeTabBarView()
    }
}
