//
//  CardCollectionViewCell.swift
//  Pairs!
//
//  Created by Khumar Girdhar on 29/06/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var frontCardView: UIImageView!
    @IBOutlet weak var backCardView: UIImageView!
   
    var card: Card? {
        didSet {
            setUpCard()
        }
    }
    
    func setUpCard() {
        guard let card = card else { return }
        
        if card.isMatched {
            backCardView.alpha = 0
            frontCardView.alpha = 0
            return
        } else {
            backCardView.alpha = 1
            frontCardView.alpha = 1
        }
        
        frontCardView.image = UIImage(named: card.name)
        frontCardView.contentMode = .scaleAspectFit
        
        if card.isFlipped {
            UIView.transition(from: backCardView, to: frontCardView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews])
        } else {
            UIView.transition(from: frontCardView, to: backCardView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    func flip() {
        UIView.transition(from: backCardView, to: frontCardView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(from: self.frontCardView, to: self.backCardView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    func clearCards() {
        backCardView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontCardView.alpha = 0
        }, completion: nil)

    }
}
