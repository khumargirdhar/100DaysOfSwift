//
//  GameScene.swift
//  Target Practice!
//
//  Created by Khumar Girdhar on 27/05/21.
//

import SpriteKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var timeRemainingLabel: SKLabelNode!
    var background: SKSpriteNode!
    var gameTimer: Timer!
    var countdownTimer: Timer!
    var isGameOver = false
    var possibleTargets = ["target0", "target1", "target2", "target3", "target4"]
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var secondsRemaining = 60 {
        didSet {
            timeRemainingLabel.text = "Seconds Remaining: \(secondsRemaining)"
        }
    }
  
    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        addChild(background)
        background.zPosition = -1
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: 16, y: 16)
        addChild(scoreLabel)
        
        score = 0
        
        timeRemainingLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeRemainingLabel.position = CGPoint(x: 25, y: 25)
        timeRemainingLabel.fontSize = 48
        addChild(timeRemainingLabel)
        
        physicsWorld.gravity = .zero
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func createTarget() {
        guard let target = possibleTargets.randomElement() else { return }
        
        
    }
    
    @objc func updateTimer() {
        secondsRemaining -= 1
        
        if secondsRemaining == 0 { isGameOver = true }
        if isGameOver {
            countdownTimer.invalidate()
            gameTimer.invalidate()
            
            let gameOver = SKLabelNode(fontNamed: "Chalkduster")
            gameOver.position = CGPoint(x: 512, y: 384)
            addChild(gameOver)
            gameOver.zPosition = 1
        }
    }
    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}
