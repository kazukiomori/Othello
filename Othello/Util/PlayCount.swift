//
//  UserDefaults.swift
//  Othello
//
//  Created by Kazuki Omori on 2024/01/02.
//

import UIKit

class PlayCount {
    static let shared = PlayCount()
    
    func getPlayCount() -> Int {
        UserDefaults.standard.integer(forKey: "playCount")
    }
    
    func plusPlayCount() {
        var playCount = getPlayCount()
        return playCount += 1
    }
    
    func resetPlayCount() {
        UserDefaults.standard.set(0, forKey: "playCount")
    }
}
