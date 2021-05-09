//
//  ViewController.swift
//  Project2
//
//  Created by Khumar Girdhar on 03/04/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scoreButtonTapped))
        
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria","poland","russia","spain","uk","us"]
        
        Button1.layer.borderWidth = 1
        Button2.layer.borderWidth = 1
        Button3.layer.borderWidth = 1
        
        Button1.layer.borderColor = UIColor.lightGray.cgColor
        Button2.layer.borderColor = UIColor.lightGray.cgColor
        Button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
    }
        
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        Button1.setImage(UIImage(named: countries[0]), for: .normal)
        Button2.setImage(UIImage(named: countries[1]), for: .normal)
        Button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + " [Score = \(score)]"
        count += 1
    }
    
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        }else{
            title = "Wrong! This flag is of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        if count==10 {
            let ac = UIAlertController(title: title,message: "Your Final Score is \(score)", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Play 'Guess The Flag' again?", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
            score = 0
        }
        else {
            let ac = UIAlertController(title: title,message: nil, preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
        
        }
    }
    
    @objc func scoreButtonTapped() {
        
        let vc = UIActivityViewController(activityItems: ["Your score is \(score)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
}

