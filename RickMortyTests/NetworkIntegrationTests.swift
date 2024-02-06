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
    
    func test_canLoadItemsFromServer() {
        runAsyncTest {
            let sut = try await MortyManager.shared.fetchCharacter(link: MortyManager.charcterURL)
            guard let results = sut.results else { return XCTFail("No items founded or loaded from `Morty` server") }

            XCTAssertFalse(results.isEmpty)
        }
    }
    
    func test_loadsNextPageOnRequest() {
        runAsyncTest {
            let firstPageResponse = try await MortyManager.shared.fetchCharacter(link: MortyManager.charcterURL)
            guard let resultsReponseOne = firstPageResponse.results else { return XCTFail("No items founded or loaded from `Morty` server") }
           
            let secondPageResponse = try await MortyManager.shared.fetchCharacter(link: "\(MortyManager.charcterURL)?page=2")
            guard let resultsReponseTwo = secondPageResponse.results else { return XCTFail("No items founded or loaded from `Morty` server") }
            
            XCTAssertTrue((resultsReponseOne + resultsReponseTwo).count > resultsReponseTwo.count)
        }
    }
    
    func test_compareRenderedItemsCountWithNetworkResponseCount() {
        runAsyncTest {
            let sut = await MortyController(nextPage: MortyModel.MortyModelInfo(next: MortyManager.charcterURL))
            await sut.loadViewIfNeeded()
        
            await sut.fetchCharacters {
                let response = try await MortyManager.shared.fetchCharacter(link: MortyManager.charcterURL)
                let renderedItems = await sut.numberOfRenderedItems()

                /// The renderedItems count is duplicated, as items are loaded both in viewDidLoad and in this test method, resulting in a doubling of the loadedItems total.
                guard let loadedItemsCount = response.results?.count else { return XCTFail("No items founded or loaded from `Morty` server") }
                XCTAssertEqual(renderedItems, loadedItemsCount * 2)
            }
        }
    }
}

/// DLS Helper
fileprivate extension MortyController {
    func numberOfRenderedItems() -> Int {
        rootView.networkDTO.count
    }
}
