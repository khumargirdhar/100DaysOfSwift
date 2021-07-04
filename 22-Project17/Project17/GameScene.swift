//
//  GameScene.swift
//  Project17
//
//  Created by Khumar Girdhar on 23/05/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var enemyCount = 0
    var gameOverLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
   
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        //Player is being added in newGame()
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        newGame()
    }
    
    @objc func createEnemy() {
        //Challenge 2
        enemyCount += 1
        
        //Challenge 3
        if !isGameOver {
            guard let enemy = possibleEnemies.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0     //how fast friction works to slow down                                                                           enemy
            sprite.physicsBody?.angularDamping = 0     //how fast friction works to slow                                                                      spinning enemy
            
            //Challenge 2
            if enemyCount == 20 {
                gameTimer?.invalidate()                             //To avoid multiple timers
                gameTimer = Timer.scheduledTimer(timeInterval: gameTimer!.timeInterval - 0.1, target: self, selector: #selector(createEnemy), userInfo: self, repeats: true)
                
                enemyCount = 0
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        
        player.position = location
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isGameOver else { return }
        
        gameOver()
    }
    
    //Challenge 1
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if !isGameOver {
            gameOver()
            return
        }

//        let location = touch.location(in: self)
//        let objects = nodes(at: location)
//
//        for object in objects {
//            if object.name == "newGame" {
//                newGame()
//            }
//        }
    }
    
    func gameOver() {
        
        isGameOver = true
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        gameTimer?.invalidate()
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 48
        addChild(gameOverLabel)
        
//        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
//        newGameLabel.horizontalAlignmentMode = .center
//        newGameLabel.position = CGPoint(x: 512, y: 324)
//        newGameLabel.text = "NEW GAME"
//        newGameLabel.fontSize = 30
//        newGameLabel.name = "newGame"
//        addChild(newGameLabel)
        
    }
    
    func newGame() {
        guard !isGameOver else { return }
        
        isGameOver = false
        score = 0
        
        if let gameOverLabel = gameOverLabel {
            gameOverLabel.removeFromParent()
        }
        if let newGameLabel = newGameLabel {
            newGameLabel.removeFromParent()
        }
        
        for node in children {
            if node.name == "enemy" {
                node.removeFromParent()
            }
        }
        
        player.position = CGPoint(x: 100, y: 384)
        addChild(player)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
}
