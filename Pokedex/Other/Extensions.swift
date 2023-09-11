//
//  Extensions.swift
//  Pokedex
//
//  Created by Carson Gross on 9/10/23.
//

import SwiftUI

extension String {
    func firstLetterCapitalized() -> String {
        prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
