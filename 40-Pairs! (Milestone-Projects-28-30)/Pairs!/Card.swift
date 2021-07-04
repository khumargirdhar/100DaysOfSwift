//
//  Card.swift
//  Pairs!
//
//  Created by Khumar Girdhar on 29/06/21.
//

import Foundation

class Card {
    var name: String
    var isMatched: Bool = false
    var isFlipped: Bool = false
    
    init(name: String) {
        self.name = name
    }
}
