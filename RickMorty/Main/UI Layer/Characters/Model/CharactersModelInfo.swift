//
//  CharactersModelInfo.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 06/02/24.
//

import Foundation

struct CharactersModelInfo: Codable {
    let count, pages: Int
    let next, prev: String?
    
    init(next: String, prev: String = "", count: Int = 0, pages: Int = 0) {
        self.next = next
        self.prev = prev
        self.count = count
        self.pages = pages
    }
}
