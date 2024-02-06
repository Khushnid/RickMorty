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
    func makeSut() -> MortyController {
        let sut = MortyController(nextPage: MortyModelInfo(next: ""))
        sut.overrideUserInterfaceStyle = .dark
        sut.loadViewIfNeeded()
        return sut
    }
}

fileprivate extension MortyController {
    func loadWithContent() {
        setDataSource(dataSource: [
            MortyModelResult(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                gender: "Male",
                image: nil,
                origin: nil,
                location: MortyModelResult.MortyModelLocation(
                    name: "Citadel of Ricks",
                    url: ""
                )
            ),
            
            MortyModelResult(
                id: 2,
                name: "Morty Smith",
                status: "Alive",
                species: "Human",
                gender: "Male",
                image: nil,
                origin: nil,
                location: MortyModelResult.MortyModelLocation(
                    name: "Citadel of Ricks",
                    url: ""
                )
            )
        ])
    }
    
    func loadContentWithMissingDetails() {
        setDataSource(dataSource: [
            MortyModelResult(
                id: 1,
                name: nil,
                status: nil,
                species: nil,
                gender: "Male",
                image: nil,
                origin: nil,
                location: MortyModelResult.MortyModelLocation(
                    name: "Citadel of Ricks",
                    url: ""
                )
            )
        ])
    }
}
