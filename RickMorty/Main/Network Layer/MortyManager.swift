//
//  MortyManager.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

actor MortyManager {
    static let shared = MortyManager()
    private init() {}
    
    private let decoder = JSONDecoder()
}

extension MortyManager {
    private enum Constants {
        static let charcterURL = baseURL + characterEndpoint

        static let baseURL = "https://rickandmortyapi.com/api/"
        static let characterEndpoint = "character"
    }
    
    func fetchCharacter(link: String) async throws -> MortyModel {
        do {
            guard let characterEndpoint = URL(string: link.isEmpty ? Constants.charcterURL : link) else { throw URLError(.badURL) }
            print(characterEndpoint)
            let (data, response) = try await URLSession.shared.data(from: characterEndpoint)
            
            guard let responseData = handleResponse(data: data, response: response) else { throw URLError(.badServerResponse) }
            return try decoder.decode(MortyModel.self, from: responseData)
        } catch {
            throw error
        }
    }
}
