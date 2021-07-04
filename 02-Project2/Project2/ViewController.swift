//
//  ViewController.swift
//  Project2
//
//  Created by Khumar Girdhar on 03/04/21.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var count = 0
    var highestScore = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share Score", style: .plain, target: self, action: #selector(scoreButtonTapped))
        
        //Project 21 challenge 3
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Remind", style: .plain, target: self, action: #selector(registerLocal))
        
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria","poland","russia","spain","uk","us"]
        
        Button1.layer.borderWidth = 1
        Button2.layer.borderWidth = 1
        Button3.layer.borderWidth = 1
        
        Button1.layer.borderColor = UIColor.lightGray.cgColor
        Button2.layer.borderColor = UIColor.lightGray.cgColor
        Button3.layer.borderColor = UIColor.lightGray.cgColor
        
        //Project 12 Challenge 2
        let defaults = UserDefaults.standard
                
        highestScore = defaults.object(forKey: "HighestScore") as? Int ?? 0
        
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
        var message: String
        
        //Project 15 - Challenge 3
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0.5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { finished in
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0.5, options: []) {
                sender.transform = .identity
            }
        }

        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        }else{
            title = "Wrong! This flag is of \(countries[sender.tag].uppercased())"
            score -= 1
        }
 
        if count==10 {
            
            //Project 12 Challenge 2
            if score > highestScore {
                title = "New High Score:  \(score)"
                message = "Previous High Score was \(highestScore)"
                highestScore = score
                save()
            } else {
                title = "Final Score!"
                message = "Your final score is \(score)"
            }
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play 'Guess The Flag' again?", style: .default, handler: askQuestion))
            present(ac,animated:true)
            
            count = 0
            score = 0
            
        } else {
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
    
    //Project 12 challenge 2
    func save() {
        let defaults = UserDefaults.standard
        
        defaults.set(highestScore,forKey: "savedScore")
    }
    
    //Project 21 challenge 3
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permissions granted")
                self.scheduleLocal()         //scheduling daily notifications
            } else {
                print("Notification permissions denied")
            }
        }
    }
    
    //Project 21 challenge 3
    func scheduleLocal() {          //FOR TESTING PURPOSE - 5 SEC NOTIFICATION
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Hey! Wanna play FLAGS!?"
        content.body = "It's been a whole day since you played FLAGS!. Come score a high score"
        content.categoryIdentifier = "reminder"
        content.userInfo = ["customData": "fizzBuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 00
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let content = UNUserNotificationCenter.current()
        content.delegate = self
        
        let play = UNNotificationAction(identifier: "play", title: "Play now!", options: .foreground)
        let categories = UNNotificationCategory(identifier: "reminder", actions: [play], intentIdentifiers: [], options: [])
        
        content.setNotificationCategories([categories])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("customData recieved \(customData)")
            
            switch response.actionIdentifier {
            
            case UNNotificationDefaultActionIdentifier:
                print("Default action")
                remindDaily()
                
                let ac = UIAlertController(title: "Daily reminders", message: "You will be notified daily to play FLAGS!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                
            case "play":
                print("Play action tapped")
                remindDaily()
                
                let ac = UIAlertController(title: "Welcome back!", message: "You pressed Play Now!, We listened!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func remindDaily() {  //FOR ACTUAL DAILY REMINDER - %AT 6PM DAILY
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Hey! Wanna play FLAGS!?"
        content.body = "It's been a whole day since you played FLAGS!. Come score a high score"
        content.categoryIdentifier = "reminder"
        content.userInfo = ["customData": "fizzBuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}

