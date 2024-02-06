//
//  XCTestCase+Helpers.swift
//  RickMortyTests
//
//  Created by Khushnidjon Keldiboev on 06/02/24.
//

import XCTest

extension XCTestCase {
    func runAsyncTest(
        named testName: String = #function,
        in file: StaticString = #file,
        at line: UInt = #line,
        withTimeout timeout: TimeInterval = 2.0,
        test: @escaping () async throws -> Void
    ) {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = expectation(description: testName)

        Task {
            do {
                try await test()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        guard let thrownError else { return }
        XCTFail("Async error thrown: \(thrownError)", file: file, line: line)
    }
}
