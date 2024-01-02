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
        var playCountIncrement = getPlayCount()
        playCountIncrement += 1
        UserDefaults.standard.set(playCountIncrement, forKey: "playCount")
    }
    
    func resetPlayCount() {
        UserDefaults.standard.set(0, forKey: "playCount")
    }
}
