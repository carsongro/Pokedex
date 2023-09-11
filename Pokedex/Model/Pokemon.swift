//
//  Pokemon.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import Foundation

// MARK: Pokemon
struct Pokemon: Codable, Identifiable {
    let abilities: [Ability]
    let base_experience: Int
    let forms: [Species]
    let game_indices: [GameIndex]
    let height: Int
    let held_items: [HeldItem]
    let id: Int
    let is_default: Bool
    let location_area_encounters: String
    let moves: [Move]
    let name: String
    let order: Int
    let past_types: [PastType]
    let species: Species
    let sprites: Sprites
    let stats: [Stat]
    let types: [PokemonType]
    let weight: Int
}

// MARK: Ability
struct Ability: Codable {
    let ability: Species
    let is_hidden: Bool
    let slot: Int
}

// MARK: Species
struct Species: Codable {
    let name: String
    let url: String
}

// MARK: GameIndex
struct GameIndex: Codable {
    let game_index: Int
    let version: Species
}

// MARK: Move
struct Move: Codable {
    let move: Species
    let version_group_details: [VersionGroupDetail]
}

// MARK: VersionGroupDetail
struct VersionGroupDetail: Codable {
    let level_learned_at: Int
    let move_learn_method: Species
    let version_group: Species
}

// MARK: GenerationVIII
struct GenerationVIII: Codable {
    let icons: VersionSprites?
}

// MARK: GenerationVII
struct GenerationVII: Codable {
    let icons: VersionSprites?
    let ultraSunUltraMoon: VersionSprites
    
    enum CodingKeys: String, CodingKey {
        case icons
        case ultraSunUltraMoon = "ultra-sun-ultra-moon"
    }
}

// MARK: GenerationVI
struct GenerationVI: Codable {
    let omegaRubyAlphaSapphire: VersionSprites
    let XY: VersionSprites
    
    enum CodingKeys: String, CodingKey {
        case omegaRubyAlphaSapphire = "omegaruby-alphasapphire"
        case XY = "x-y"
    }
}

// MARK: GenerationV
struct GenerationV: Codable {
    let blackWhite: VersionSprites
    
    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
}

// MARK: GenerationIV
struct GenerationIV: Codable {
    let diamondPearl: VersionSprites
    let heartGoldSoulSilver: VersionSprites
    
    enum CodingKeys: String, CodingKey {
        case diamondPearl = "diamond-pearl"
        case heartGoldSoulSilver = "heartgold-soulsilver"
    }
}

// MARK: GenerationIII
struct GenerationIII: Codable {
    let emerald: VersionSprites
    let fireRedLeafGreen: VersionSprites
    let rubySapphire: VersionSprites
    
    enum CodingKeys: String, CodingKey {
        case emerald
        case fireRedLeafGreen = "firered-leafgreen"
        case rubySapphire = "ruby-sapphire"
    }
}

// MARK: GenerationII
struct GenerationII: Codable {
    let crystal: VersionSprites
    let gold: VersionSprites
    let silver: VersionSprites
}

// MARK: GenerationI
struct GenerationI: Codable {
    let redBlue: VersionSprites
    let yellow: VersionSprites
    
    enum CodingKeys: String, CodingKey {
        case redBlue = "red-blue"
        case yellow = "yellow"
    }
}
// MARK: Versions
struct Versions: Codable {
    let generationI: GenerationI
    let generationII: GenerationII
    let generationIII: GenerationIII
    let generationIV: GenerationIV
    let generationV: GenerationV
    let generationVI: GenerationVI
    let generationVII: GenerationVII
    let generationVIII: GenerationVIII
    
    enum CodingKeys: String, CodingKey {
        case generationI = "generation-i"
        case generationII = "generation-ii"
        case generationIII = "generation-iii"
        case generationIV = "generation-iv"
        case generationV = "generation-v"
        case generationVI = "generation-vi"
        case generationVII = "generation-vii"
        case generationVIII = "generation-viii"
    }
}

// MARK: Sprites
struct Sprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_Female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
    let other: Other?
    let versions: Versions
}

// MARK: VersionSprites
struct VersionSprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_Female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
    let other: Other?
    let animated: AnimatedSprites?
}

// MARK: AnimatedSprites
struct AnimatedSprites: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_Female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

// MARK: Other (Sprites)
struct Other: Codable {
    let back_default: String?
    let back_female: String?
    let back_shiny: String?
    let back_shiny_Female: String?
    let front_default: String?
    let front_female: String?
    let front_shiny: String?
    let front_shiny_female: String?
}

// MARK: Stat
struct Stat: Codable {
    let base_stat: Int
    let effort: Int
    let stat: Species
}

// MARK: PokemonType
struct PokemonType: Codable {
    let slot: Int
    let type: Species
}

// MARK: HeldItem
struct HeldItem: Codable {
    let name: String?
    let url: String?
}

// MARK: PastType
struct PastType: Codable {
    let name: String
    let url: String
}
