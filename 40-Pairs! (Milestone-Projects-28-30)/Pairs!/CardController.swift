//
//  CardController.swift
//  Pairs!
//
//  Created by Khumar Girdhar on 29/06/21.
//

import Foundation

class CardController {
    
    static func fetchCards() -> [Card] {
        var cards: [Card] = []
        var usedNumbers: [Int] = []
        
        while usedNumbers.count < 16 {
            let randomNumber = Int.random(in: 1...16)
            
            if !usedNumbers.contains(randomNumber) {
                let card1 = Card(name: "card\(randomNumber)")
                cards.append(card1)
                let card2 = Card(name: "card\(randomNumber)")
                cards.append(card2)
                
                usedNumbers.append(randomNumber)
            }
        }
        
        return cards.shuffled()
        
    }
}
