//
//  MortyHashed.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 26/01/24.
//

import Foundation

struct MortyHashed: Hashable {
    let hasherID = UUID()
    let model: MortyModel.MortyModelResult
    
    init(model: MortyModel.MortyModelResult) {
        self.model = model
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hasherID)
    }
    
    static func == (lhs: MortyHashed, rhs: MortyHashed) -> Bool {
        return lhs.hasherID == rhs.hasherID
    }
}