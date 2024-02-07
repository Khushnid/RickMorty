//
//  CharactersModelResult.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 06/02/24.
//

import Foundation

struct CharactersModelResult: Codable {
    let id: Int?
    let name, status, species, gender, image: String?
    let origin, location: MortyModelLocation?
}

extension CharactersModelResult: Hashable {
    static func == (lhs: CharactersModelResult, rhs: CharactersModelResult) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
