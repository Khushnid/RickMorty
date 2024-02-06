//
//  MortyManager.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

actor MortyManager {
    private init() {}
    static let shared = MortyManager()
    
    private enum Constants {
        static let baseURL = "https://rickandmortyapi.com/api/"
        static let characterEndpoint = "character"
    }
    
    static let charcterURL = Constants.baseURL + Constants.characterEndpoint
}

extension MortyManager {
    func fetchCharacter(link: String) async throws -> CharactersModel {
        do {
            guard let endpoint = URL(string: link) else { throw URLError(.badURL) }
            let (data, response) = try await URLSession.shared.data(from: endpoint)
           
            guard validate(response: response) else { throw URLError(.badServerResponse) }
            return try JSONDecoder().decode(CharactersModel.self, from: data)
        } catch {
            throw error
        }
    }
}
