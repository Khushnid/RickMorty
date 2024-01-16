//
//  MortyManager+Helpers.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

extension MortyManager {
    func handleResponse(data: Data?, response: URLResponse?) -> Data? {
        guard let data, let response = response as? HTTPURLResponse else { return nil }
        return (200...299) ~= response.statusCode ? data : nil
    }
}
