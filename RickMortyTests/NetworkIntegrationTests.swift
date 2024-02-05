//
//  RickMortyTests.swift
//  RickMortyTests
//
//  Created by Khushnidjon Keldiboev on 30/01/24.
//

import XCTest
@testable import RickMorty

final class NetworkIntegrationTests: XCTestCase {
    /// These tests involve actual network requests, which can be resource-intensive.
    /// Consider placing them in a separate test scheme to avoid unnecessary costs.

    /// Example:
    /// `NetworkIntegrationTests` scheme for tests requiring network requests.
    
    func test_canLoadItemsFromServer() async {
        do {
            let networkExpectation = expectation(description: "Need to wait for response from `Morty` server")
            let sut = try await MortyManager.shared.fetchCharacter(link: MortyManager.charcterURL)

            networkExpectation.fulfill()
            await fulfillment(of: [networkExpectation], timeout: 2.0)

            guard let results = sut.results else { return XCTFail("No items founded or loaded from `Morty` server") }
            XCTAssertFalse(results.isEmpty)
        } catch {
            XCTFail("Can't load from `Morty` server. Reason: \n\(error.localizedDescription)")
        }
    }
    
    func test_loadsNextPageOnRequest() async {
        do {
            let networkExpectationOne = expectation(description: "Need to wait for response from `Morty` server")
            let networkExpectationTwo = expectation(description: "Need to wait for response from `Morty` server")
            
            let firstPageResponse = try await MortyManager.shared.fetchCharacter(link: MortyManager.charcterURL)
            let secondPageResponse = try await MortyManager.shared.fetchCharacter(link: "\(MortyManager.charcterURL)?page=2")

            networkExpectationOne.fulfill()
            await fulfillment(of: [networkExpectationOne], timeout: 2.0)
            guard let resultsReponseOne = firstPageResponse.results else { return XCTFail("No items founded or loaded from `Morty` server") }
            
            networkExpectationTwo.fulfill()
            await fulfillment(of: [networkExpectationTwo], timeout: 2.0)
            guard let resultsReponseTwo = secondPageResponse.results else { return XCTFail("No items founded or loaded from `Morty` server") }
            
            XCTAssertTrue((resultsReponseOne + resultsReponseTwo).count > resultsReponseTwo.count)
        } catch {
            XCTFail("Can't load from `Morty` server. Reason: \n\(error.localizedDescription)")
        }
    }
}
