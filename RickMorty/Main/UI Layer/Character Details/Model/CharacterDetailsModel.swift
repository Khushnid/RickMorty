//
//  CharacterDetailsModel.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 07/02/24.
//

import Foundation

struct CharacterDetailsModel: Codable {
    let id: Int?
    let episode: [String]?
    let origin, location: MortyModelLocation?
    let name, status, species, type, gender, image, url, created: String?
}
