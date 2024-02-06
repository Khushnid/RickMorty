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
}
