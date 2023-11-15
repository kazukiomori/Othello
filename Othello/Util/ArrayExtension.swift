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
