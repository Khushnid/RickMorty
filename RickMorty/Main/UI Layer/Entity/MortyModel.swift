//
//  MortyModel.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

struct MortyModel: Codable {
    let info: MortyModelInfo
    let results: [MortyModelResult]?
    
    struct MortyModelInfo: Codable {
        let next, prev: String?
        let count, pages: Int
        
        init(next: String, prev: String = "", count: Int = 0, pages: Int = 0) {
            self.next = next
            self.prev = prev
            self.count = count
            self.pages = pages
        }
    }
    
    struct MortyModelResult: Codable {
        init(
            name: String? = nil,
            status: String? = nil,
            species: String? = nil,
            gender: String? = nil,
            image: String? = nil,
            origin: MortyModel.MortyModelResult.MortyModelLocation? = nil,
            location: MortyModel.MortyModelResult.MortyModelLocation? = nil
        ) {
            self.name = name
            self.status = status
            self.species = species
            self.gender = gender
            self.image = image
            self.origin = origin
            self.location = location
        }
        
        let name, status, species, gender, image: String?
        let origin, location: MortyModelLocation?
        
        struct MortyModelLocation: Codable {
            let name: String?
            let url: String?
        }
    }
}
