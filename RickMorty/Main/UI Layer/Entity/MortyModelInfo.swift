//
//  MortyModelInfo.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 06/02/24.
//

import Foundation

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
