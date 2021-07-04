//
//  GameScene.swift
//  Project26
//
//  Created by Khumar Girdhar on 15/06/21.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
    case teleport2 = 64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    
    var level = 0 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //Challenge 3
    var teleportPosition: CGPoint!
    var teleport2Position: CGPoint!
   
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Practice Level"
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.position = CGPoint(x: 512, y: 725)
        levelLabel.zPosition = 2
        addChild(levelLabel)
        
        loadLevel(levelName: "level0")
        createPlayer(at: 96, 672)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadLevel(levelName: String) {
        guard let levelURL = Bundle.main.url(forResource: levelName, withExtension: "txt") else { fatalError("Could not find Level\(level).txt in the app bundle.") }
        guard let levelString = try? String(contentsOf: levelURL) else { fatalError("Could not load level1.txt from the app bundle.") }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    //load wall
                    loadWall(at: position);
                    
                } else if letter == "v" {
                    //load vortex
                    loadVortex(at: position)
                    
                } else if letter == "s" {
                    //load star
                    loadStar(at: position)
                    
                } else if letter == "f" {
                    //load finish point
                    loadFinish(at: position)
                    
                } else if letter == "t" {
                    //load teleport
                    loadTeleport(at: position)

                } else if letter == "T" {
                    //load teleport2
                    loadTeleport2(at: position)
                    
                } else if letter == " " {
                    //this is an empty space - do nothing!
                    
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    //Challenge 1
    func loadWall(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.name = "wall"
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        
        addChild(node)
    }
    
    func loadVortex(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        addChild(node)
    }
    
    func loadStar(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        
        addChild(node)
    }
    
    func loadFinish(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        
        addChild(node)
    }
    
    //Challenge 3
    func loadTeleport(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport")
        node.name = "teleport"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        teleportPosition = position
        
        addChild(node)
    }
    
    func loadTeleport2(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport2")
        node.name = "teleport2"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        teleport2Position = position
        
        addChild(node)
    }
    
    func createPlayer(at x: Int = 96 ,_ y: Int = 672) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: x, y: y)
        player.zPosition = 1
        player.name = "player"
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        //As we're in landscape mode, so we have to invert the coordinates too - x=y & y=x
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            //next level?
            
            //Challenge 2
            for child in self.children {
                if child.name == "wall" || child.name == "vortex" || child.name == "star" || child.name == "finish" || child.name == "player" || child.name == "teleport" || child.name == "teleport2" {
                    child.removeFromParent()
                }
            }
            
            SKView.animate(withDuration: 1) { [weak self] in
                self?.scene?.view?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self?.scene?.view?.transform = .identity
            }
            level += 1
            createPlayer()
            loadLevel(levelName: "level\(level)")
        }
        
        if node.name == "teleport" {
            player.physicsBody?.isDynamic = false
            player.physicsBody?.collisionBitMask = 0
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer(at: Int((self?.teleport2Position.x)!), Int((self?.teleport2Position.y)!))
                self?.player.physicsBody?.isDynamic = true
                self?.player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
            }
        }
        
//        if node.name == "teleport2" {
//            player.physicsBody?.isDynamic = false
//            player.physicsBody?.collisionBitMask = 0
//
//            let move = SKAction.move(to: node.position, duration: 0.25)
//            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
//            let remove = SKAction.removeFromParent()
//            let sequence = SKAction.sequence([move, scale, remove])
//
//            player.run(sequence) { [weak self] in
//                self?.createPlayer(at: Int((self?.teleportPosition.x)!), Int((self?.teleportPosition.y)!))
//                self?.player.physicsBody?.isDynamic = true
//                self?.player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
//            }
//        }
    }
}
