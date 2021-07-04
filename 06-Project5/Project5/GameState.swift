//
//  GameState.swift
//  Project5
//
//  Created by Khumar Girdhar on 10/05/21.
//

import Foundation

struct GameState: Codable {
    var currentWord: String
    var usedWords = [String]()
}
