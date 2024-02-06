//
//  CharactersModel.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

struct CharactersModel: Codable {
    let info: CharactersModelInfo
    let results: [CharactersModelResult]?
}
