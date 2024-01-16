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
    
    func fetchCharacter() async throws -> [MortyModelResult] {
        do {
            guard let characterEndpoint = URL(string: Constants.charcterURL) else { throw URLError(.badURL) }
            let (data, response) = try await URLSession.shared.data(from: characterEndpoint)
            
            guard let responseData = handleResponse(data: data, response: response) else { throw URLError(.badServerResponse) }
            guard let results = try decoder.decode(MortyModel.self, from: responseData).results else { throw URLError(.cannotDecodeContentData) }
            
            return results
        } catch {
            throw error
        }
    }
}
