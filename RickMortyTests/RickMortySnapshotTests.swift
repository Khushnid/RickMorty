//
//  RickMortyTests.swift
//  RickMortyTests
//
//  Created by Khushnidjon Keldiboev on 30/01/24.
//

import XCTest
import SnapshotTesting
@testable import RickMorty

final class RickMortySnapshotTests: XCTestCase {
    func test_contentWithNoData() {
        let sut = makeSut()
        assertSnapshot(of: sut, as: .image(on: .iPhoneX), record: false)
    }
    
    func test_contentWithDataAndLoader() {
        let sut = makeSut()
        sut.loadWithContent()

        assertSnapshot(of: sut, as: .image(on: .iPhoneX), record: false)
    }
    
    func test_contentWithMissingDetailsAndLoader() {
        let sut = makeSut()
        sut.loadContentWithMissingDetails()

        assertSnapshot(of: sut, as: .image(on: .iPhoneX), record: false)
    }
}

private extension RickMortySnapshotTests {
    func makeSut() -> CharactersController {
        let controller = CharactersController(
            nextPage: CharactersModelInfo(next: MortyManager.charcterURL),
            production: false
        )
        
        controller.overrideUserInterfaceStyle = .dark
        controller.loadViewIfNeeded()
        return controller
    }
}

fileprivate extension CharactersController {
    func loadWithContent() {
        setDataSource(dataSource: [
            CharactersModelResult(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                gender: "Male",
                image: nil,
                origin: nil,
                location: MortyModelLocation(name: "Citadel of Ricks", url: "")
            ),
            
            CharactersModelResult(
                id: 2,
                name: "Morty Smith",
                status: "Alive",
                species: "Human",
                gender: "Male",
                image: nil,
                origin: nil,
                location: MortyModelLocation(name: "Citadel of Ricks", url: "")
            )
        ])
    }
    
    func loadContentWithMissingDetails() {
        setDataSource(dataSource: [
            CharactersModelResult(
                id: 1,
                name: nil,
                status: nil,
                species: nil,
                gender: "Male",
                image: nil,
                origin: nil,
                location: MortyModelLocation(name: "Citadel of Ricks", url: "")
            )
        ])
    }
}
