//
//  OthelloTests.swift
//  OthelloTests
//
//  Created by Kazuki Omori on 2023/07/01.
//

import XCTest
@testable import Othello

final class OthelloTests: XCTestCase {
    
    func test_Positionのテスト() throws {
        XCTAssertNotNil(Position(x: 0, y: 0))
        XCTAssertNil(Position(x: 8, y: 0))
        XCTAssertNil(Position(x: 0, y: 8))
        XCTAssertNil(Position(x: -1, y: 0))
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
