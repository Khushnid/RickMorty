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
        let sut = MortyController()
        
        sut.overrideUserInterfaceStyle = .dark
        sut.loadViewIfNeeded()
        
        assertSnapshot(of: sut, as: .image, record: false)
    }
    
    func test_contentWithDataAndLoader() {
        let sut = MortyController()
        
        sut.overrideUserInterfaceStyle = .dark
        sut.loadViewIfNeeded()
        sut.loadWithContentAndLoader()

        assertSnapshot(of: sut, as: .image, record: false)
    }
}

fileprivate extension MortyController {
    func loadWithContentAndLoader() {
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
}
