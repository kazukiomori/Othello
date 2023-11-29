//
//  ArrayExtension.swift
//  Othello
//
//  Created by Kazuki Omori on 2023/11/16.
//

import Foundation

extension Array where Element: Equatable {
    func removeSequence() -> [Element] {
        switch count {
        case 0:
            return []
        case 1:
            return self
        default:
            if self[0] == self[1] {
                return Array(self.dropFirst()).removeSequence()
            } else {
                return [self[0]] + Array(self.dropFirst()).removeSequence()
            }
        }
    }
}

extension Array where Element == FieldStatus {
    func isSetOthello(color: Color) -> Bool {
        let removedArray = self.removeSequence()
        return removedArray.count >= 3 &&
        removedArray[0] == .空 &&
        removedArray[1].color == color.reverseColor &&
        removedArray[2].color == color &&
        self[1] != .空 &&
        self[2] != .空
    }
}
