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
    
    func test_マス目のテスト() throws {
        XCTAssertEqual(FieldViewController().getStatus(position: .init(x: 0, y: 0)!), .空)
        XCTAssertEqual(FieldViewController().getStatus(position: .init(x: 3, y: 3)!), .白)
        XCTAssertEqual(FieldViewController().getStatus(position: .init(x: 3, y: 4)!), .黒)
    }
}
