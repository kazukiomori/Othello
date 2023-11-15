//
//  Position.swift
//  Othello
//
//  Created by Kazuki Omori on 2023/11/15.
//

import Foundation

struct Position {
    init?(x: Int, y: Int) {
        guard (0..<8).contains(x) &&
                (0..<8).contains(y) else {
            return nil
        }
        self.x = x
        self.y = y
    }
    
    let x: Int
    let y: Int
    
    func getNextPosition(direction: direction) -> Position? {
        Position(x: x + direction.dx, y: y + direction.dy)
    }
}
