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
        assertSnapshot(of: sut, as: .image, record: false)
    }
    
    func test_contentWithDataAndLoader() {
        let sut = makeSut()
        sut.loadWithContent()

        assertSnapshot(of: sut, as: .image, record: false)
    }
    
    func test_contentWithMissingDetailsAndLoader() {
        let sut = makeSut()
        sut.loadContentWithMissingDetails()

        assertSnapshot(of: sut, as: .image, record: false)
    }
}

private extension RickMortySnapshotTests {
    func makeSut() -> MortyController {
        let sut = MortyController()
        sut.overrideUserInterfaceStyle = .dark
        sut.loadViewIfNeeded()
        return sut
    }
}

fileprivate extension MortyController {
    func loadWithContent() {
        setDataSource(dataSource: [
            MortyModel.MortyModelResult(
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                gender: "Male",
                image: nil,
                origin: nil,
                location: MortyModel.MortyModelResult.MortyModelLocation(
                    name: "Citadel of Ricks",
                    url: ""
                )
            ),
            
            MortyModel.MortyModelResult(
                name: "Morty Smith",
                status: "Alive",
                species: "Human",
                gender: "Male",
                image: nil,
                origin: nil,
                location: MortyModel.MortyModelResult.MortyModelLocation(
                    name: "Citadel of Ricks",
                    url: ""
                )
            )
        ])
    }
    
    func loadContentWithMissingDetails() {
        setDataSource(dataSource: [
            MortyModel.MortyModelResult(
                gender: "Male",
                location: MortyModel.MortyModelResult.MortyModelLocation(
                    name: "Citadel of Ricks",
                    url: ""
                )
            )
        ])
    }
}
