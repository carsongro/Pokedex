//
//  PokeEndpoint.swift
//  Pokedex
//
//  Created by Carson Gross on 9/9/23.
//

import Foundation

@frozen enum PokeEndpoint: String, CaseIterable, Hashable {
    /// Endpoint to get pokemon information
    case pokemon
    /// Endpoint to get item information
    case item
}
