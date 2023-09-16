//
//  PokeDetailView.swift
//  Pokedex
//
//  Created by Carson Gross on 9/13/23.
//

import SwiftUI
import Kingfisher

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct PokeDetailView: View {
    @ObservedObject var viewModel: PokeDetailViewViewModel
    
    var namespace: Namespace.ID
    
    var dismissHandler: (() -> Void)?
    
    var body: some View {
        VStack {
            // Temporary Dismiss Button
            HStack {
                Spacer()
                
                Button {
                    dismissHandler?()
                } label: {
                    ZStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
            
            VStack {
                Text(String(viewModel.pokemon.id))
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 22, weight: .regular, design: .monospaced))
                    .matchedGeometryEffect(id: String(viewModel.id), in: namespace)
                
                KFAnimatedImage(viewModel.pokemonAnimatedSpriteURL != nil ? viewModel.pokemonAnimatedSpriteURL : viewModel.pokemonSpriteURL)
                    .scaledToFit()
                    .shadow(color: .secondary, radius: 2, x: 1 , y: -1)
                    .matchedGeometryEffect(id: viewModel.pokemonSpriteURL?.absoluteString, in: namespace)
                
                Text(viewModel.pokemonName.firstLetterCapitalized())
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .lineLimit(1) //TODO: Handle this better
                    .matchedGeometryEffect(id: viewModel.pokemonName.firstLetterCapitalized(), in: namespace)
                
                ForEach(0..<100) { i in
                    VStack {
                        Text(String(i))
                    }
                }
            }
        }
        .padding(12)
        .background {
            Color(uiColor: .secondarySystemBackground)
                .cornerRadius(10)
                .shadow(color: .secondary, radius: 2, x: 3, y: 3)
                .matchedGeometryEffect(id: String(viewModel.id) + "background", in: namespace)
            GeometryReader {
                Color.clear
                    .preference(key: ScrollViewOffsetPreferenceKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
            }
        }
    }
}

struct PokeDetailView_Previews: PreviewProvider {
    @Namespace static var simulator
    
    static var previews: some View {
        PokeDetailView(
            viewModel: .init(
                pokemon: Pokemon(
                    abilities: [],
                    base_experience: nil,
                    forms: [],
                    game_indices: [],
                    height: 1,
                    held_items: [],
                    id: 502,
                    is_default: true,
                    location_area_encounters: "",
                    moves: [],
                    name: "Dewott",
                    order: 0,
                    past_types: [],
                    species: Species(
                        name: "",
                        url: ""
                    ),
                    sprites: Sprites(
                        back_default: nil,
                        back_female: nil,
                        back_shiny: nil,
                        back_shiny_Female: nil,
                        front_default: nil,
                        front_female: nil,
                        front_shiny: nil,
                        front_shiny_female: nil,
                        other: nil,
                        versions: Versions(
                            generationI: GenerationI(
                                redBlue: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                ), yellow: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                )
                            ),
                            generationII: GenerationII(
                                crystal: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                ),
                                gold: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                ),
                                silver: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                )),
                            generationIII: GenerationIII(
                                emerald: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                ),
                                fireRedLeafGreen: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                ),
                                rubySapphire: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                )
                            ),
                            generationIV: GenerationIV(
                                diamondPearl: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                ),
                                heartGoldSoulSilver: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                )
                            ),
                            generationV: GenerationV(
                                blackWhite: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/502.png",
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: AnimatedSprites(
                                        back_default: nil,
                                        back_female: nil,
                                        back_shiny: nil,
                                        back_shiny_Female: nil,
                                        front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/502.gif",
                                        front_female: nil,
                                        front_shiny: nil,
                                        front_shiny_female: nil
                                    )
                                )),
                            generationVI: GenerationVI(
                                omegaRubyAlphaSapphire: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                ),
                                XY: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                )
                            ),
                            generationVII: GenerationVII(
                                icons: nil,
                                ultraSunUltraMoon: VersionSprites(
                                    back_default: nil,
                                    back_female: nil,
                                    back_shiny: nil,
                                    back_shiny_Female: nil,
                                    front_default: nil,
                                    front_female: nil,
                                    front_shiny: nil,
                                    front_shiny_female: nil,
                                    other: nil,
                                    animated: nil
                                )
                            ),
                            generationVIII: GenerationVIII(
                                icons: nil
                            )
                        )),
                    stats: [],
                    types: [],
                    weight: 1
                )
            ),
            namespace: simulator
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
