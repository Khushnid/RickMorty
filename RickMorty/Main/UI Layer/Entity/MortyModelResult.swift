//
//  MortyModelResult.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 06/02/24.
//

import Foundation

struct MortyModelResult: Codable {
    let id: Int?
    let name, status, species, gender, image: String?
    let origin, location: MortyModelLocation?
    
    struct MortyModelLocation: Codable {
        let name: String?
        let url: String?
    }
}

extension MortyModelResult: Hashable {
    static func == (lhs: MortyModelResult, rhs: MortyModelResult) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
