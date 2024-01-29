//
//  MortyManager+Helpers.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Foundation

extension MortyManager {
    func validate(response: URLResponse?) -> Bool {
        guard let response = response as? HTTPURLResponse else { return false }
        return (200...299) ~= response.statusCode
    }
}
