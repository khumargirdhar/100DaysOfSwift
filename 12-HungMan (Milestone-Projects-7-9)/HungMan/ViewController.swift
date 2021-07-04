//
//  ViewController.swift
//  HungMan
//
//  Created by Khumar Girdhar on 02/05/21.
//

import UIKit

class ViewController: UIViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var currentAnswer: UITextField!
    var currentWord: String!
    var word: UILabel!
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var guessLabel: UILabel!
    var guesses = 0 {
        didSet {
            guessLabel.text = "Incorrect Guesses made: \(guesses)/7"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        guessLabel = UILabel()
        guessLabel.translatesAutoresizingMaskIntoConstraints = false
        guessLabel.textAlignment = .center
        guessLabel.text = "Incorrect Guesses made: \(guesses)/7"
        view.addSubview(guessLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "??????"
        currentAnswer.borderStyle = .roundedRect
        currentAnswer.font = UIFont.systemFont(ofSize: 30)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let newGame = UIButton(type: .system)
        newGame.translatesAutoresizingMaskIntoConstraints = false
        newGame.setTitle("New Game", for: .normal)
        newGame.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        view.addSubview(newGame)
        
        //constraints
        NSLayoutConstraint.activate( [
            guessLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 50),
            guessLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: guessLabel.bottomAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor,constant: 20),
            
            newGame.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            newGame.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -20),
            newGame.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        let theletters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let width = 50
        let height = 50
        
        for row in 0..<5 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
                letterButton.setTitle("?", for: .normal)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.gray.cgColor
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column*width, y: row*height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
            }
        }
        
        for (index, char) in theletters.enumerated() {
            letterButtons[index].setTitle(String(char), for: .normal)
        }
        
        for button in letterButtons {
            if button.titleLabel?.text == "?" {
                button.isHidden = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadWords), with: nil)

    }
    
    @objc func loadWords() {
        if let startWordURL = Bundle.main.url(forResource: "hungmanWords", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["KHUMAR"]
        }
        
        performSelector(onMainThread: #selector(startGame), with: nil, waitUntilDone: false)
    }
    
    
    @objc func startGame() {
        
        for button in letterButtons {
            button.isEnabled = true
        }
        
        usedWords.removeAll(keepingCapacity: true)
        
        guesses = 0
        currentWord = allWords.randomElement()
        
        currentAnswer.text = "??????"
        print(currentWord!)
        
    }

    @objc func letterTapped() {
        
    }

}

