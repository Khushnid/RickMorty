//
//  MortyManager.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

actor MortyManager {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private enum Constants {
        static let baseURL = "https://rickandmortyapi.com/api/"
        static let characterEndpoint = "character"
    }
    
    static let charcterURL = Constants.baseURL + Constants.characterEndpoint
}

// MARK: Fetch all character list
extension MortyManager {
    func fetchCharacter(link: String) async throws -> CharactersModel {
        guard let endpoint = URL(string: link) else { throw URLError(.badURL) }
        let (data, response) = try await session.data(from: endpoint)
       
        guard validate(response: response) else { throw URLError(.badServerResponse) }
        return try JSONDecoder().decode(CharactersModel.self, from: data)
    }
}

// MARK: Fetch details of specific character
extension MortyManager {
    func fetchCharacterDetails(characterID: UInt) async throws -> CharacterDetailsModel {
        guard let endpoint = URL(string: "\(MortyManager.charcterURL)/\(characterID)") else { throw URLError(.badURL) }
        let (data, response) = try await session.data(from: endpoint)
       
        guard validate(response: response) else { throw URLError(.badServerResponse) }
        return try JSONDecoder().decode(CharacterDetailsModel.self, from: data)
    }
}
