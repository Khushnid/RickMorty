//
//  XCTestCase+MemoryLeakDetector.swift
//  RickMortyTests
//
//  Created by Khushnidjon Keldiboev on 06/02/24.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(for instances: AnyObject...,
                                     file: StaticString = #filePath,
                                     line: UInt = #line) {
        for instance in instances {
            addTeardownBlock { [weak instance] in
                XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
            }
        }
    }
}
