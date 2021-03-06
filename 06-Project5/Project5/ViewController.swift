//
//  ViewController.swift
//  Project5
//
//  Created by Khumar Girdhar on 11/04/21.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var gameState = GameState(currentWord: "", usedWords: [String]())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
 
        if allWords.isEmpty {
            allWords = ["Silkworm"]
        }
//        startGame()
        
        loadGameState()
        
    }
    
    func loadGameState() {
        //Project 12 Challenge 3
        let defaults = UserDefaults.standard
        if let loadedState = defaults.object(forKey: "GameState") as? Data {
            let jsonDecoder = JSONDecoder()
            
            if let decodedState = try? jsonDecoder.decode(GameState.self, from: loadedState) {
                gameState = decodedState
            }
        }
        //Project 12 Challenge 3
        if gameState.currentWord.isEmpty {
            startGame()
        }
        else {
            loadGameStateView()
        }
    }
    
    @objc func startGame() {
        //Project 12 Challenge 3
        gameState.currentWord = allWords.randomElement() ?? "Silkworm"
        
        save()
        loadGameStateView()
    }
    
    //Project 12 Challenge 3
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let encodedState = try? jsonEncoder.encode(gameState) {
            let defaults = UserDefaults.standard
            
            defaults.set(encodedState,forKey: "GameState")
        }
    }
    
    //Project 12 Challenge 3
    func loadGameStateView() {
        title = gameState.currentWord
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameState.usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = gameState.usedWords[indexPath.row]
        save()
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self,weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
    }
        
        ac.addAction(submitAction)
        present(ac, animated: true)

}
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if !(lowerAnswer.utf16.count < 3) {
                        if !(lowerAnswer==title) {
                            gameState.usedWords.insert(lowerAnswer, at: 0)
                            //Project 12 Challenge 3
                            save()
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            return
                        } else {
                            showErrorMessage("This is the original word", "Stop fooling around!")
                        }
                    } else {
                        showErrorMessage("Word is very short", "Try guessing a bigger word!")
                    }
                    
                } else {
                    showErrorMessage("Word not recognized", "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage("Word already used", "Be more original!")
            }
        } else {
            showErrorMessage("Word is not possible", "You can't spell that word from \(title!.lowercased())")
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !gameState.usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(_ errorTitle: String, _ errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Submit", style: .default))
        present(ac,animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gameState.usedWords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic) //Row delete animation
            save()
        }
    }
    
}
