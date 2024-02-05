//
//  RickMortyTests.swift
//  RickMortyTests
//
//  Created by Khushnidjon Keldiboev on 30/01/24.
//

import XCTest
@testable import RickMorty

final class RickMortyTests: XCTestCase {
    func test_init() async {
        let sut = makeSut()
        XCTAssertEqual("2", "2")
    }
}


private extension RickMortyTests {
    func makeSut() -> MortyController {
        let sut = MortyController(nextPage: MortyModel.MortyModelInfo(next: MortyManager.charcterURL))
        sut.loadViewIfNeeded()
        return sut
    }
}
