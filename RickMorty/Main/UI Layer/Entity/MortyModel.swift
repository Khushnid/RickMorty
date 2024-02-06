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
