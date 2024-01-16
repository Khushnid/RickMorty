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
}

struct MortyModelInfo: Codable {
    let count, pages: Int?
    let next, prev: String?
}

struct MortyModelResult: Codable {
    let id: Int?
    let name: String?
    let status: MortyModelStatus?
    let species: String?
    let type: String?
    let gender: MortyModelGender?
    let origin, location: MortyModelLocation?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

struct MortyModelLocation: Codable {
    let name: String?
    let url: String?
}

enum MortyModelGender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

enum MortyModelStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
