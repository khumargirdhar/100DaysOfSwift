//
//  ViewController.swift
//  Pairs!
//
//  Created by Khumar Girdhar on 29/06/21.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var cards = [Card]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var counter = 0
    var firstCardIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pairs!"
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchCards()
    }

    private func fetchCards() {
        cards = CardController.fetchCards()
        counter = CardController.fetchCards().count
    }

    func checkForMatch(secondCardIndex: IndexPath) {
        guard let firstCardPath = firstCardIndexPath else { return }
        
        let firstCell = collectionView.cellForItem(at: firstCardPath) as? CardCollectionViewCell
        let secondCell = collectionView.cellForItem(at: secondCardIndex) as? CardCollectionViewCell
        
        let firstCard = cards[firstCardPath.row]
        let secondCard = cards[secondCardIndex.row]
        
        if firstCard.name == secondCard.name {
            firstCard.isMatched = true
            secondCard.isMatched = true
            
            firstCell?.clearCards()
            secondCell?.clearCards()
            counter -= 2
            checkGameOver()
            
        } else {
            firstCard.isFlipped = false
            secondCard.isFlipped = false
            
            firstCell?.flipBack()
            secondCell?.flipBack()
        }
        
        firstCardIndexPath = nil
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        let card = cards[indexPath.row]
        cell.card = card
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cardCell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cards[indexPath.row]
        
        if !card.isFlipped && !card.isMatched {
            cardCell.flip()
            card.isFlipped = true
            
            if firstCardIndexPath != nil {
                checkForMatch(secondCardIndex: indexPath)
            } else {
                firstCardIndexPath = indexPath
            }
        }
    }
    
    func checkGameOver() {
        if counter == 0 {
            let ac = UIAlertController(title: "ALL COMPLETE!", message: "Wanna play again?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.cards.removeAll()
                self?.fetchCards()
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }
}

