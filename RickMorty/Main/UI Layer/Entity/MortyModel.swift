//
//  MortyModel.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

struct MortyModel: Codable {
    let info: MortyModelInfo?
    let results: [MortyModelResult]?
    
    struct MortyModelInfo: Codable {
        let next: String?
    }
    
    struct MortyModelResult: Codable {
        let name, status, species, gender, image: String?
        let origin, location: MortyModelLocation?
        
        struct MortyModelLocation: Codable {
            let name: String?
            let url: String?
        }
    }
}
