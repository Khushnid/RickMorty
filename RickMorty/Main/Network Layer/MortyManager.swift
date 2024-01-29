//
//  MortyManager.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

actor MortyManager {
    private enum Constants {
        static let charcterURL = baseURL + characterEndpoint

        static let baseURL = "https://rickandmortyapi.com/api/"
        static let characterEndpoint = "character"
    }
    
    private init() {}
    static let shared = MortyManager()
}

extension MortyManager {
    func fetchCharacter(link: String) async throws -> MortyModel {
        do {
            guard let endpoint = URL(string: link.isEmpty ? Constants.charcterURL : link) else { throw URLError(.badURL) }
            let (data, response) = try await URLSession.shared.data(from: endpoint)
           
            guard validate(response: response) else { throw URLError(.badServerResponse) }
            return try JSONDecoder().decode(MortyModel.self, from: data)
        } catch {
            throw error
        }
    }
}
