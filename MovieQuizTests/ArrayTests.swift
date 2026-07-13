//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 07.05.2026.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1, 2, 3, 6, 7]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1, 2, 3, 6, 7]
        
        let value = array[safe: 7]
        
        XCTAssertNil(value)
    }
}
