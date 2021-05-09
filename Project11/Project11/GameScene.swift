//
//  GameScene.swift
//  Project11
//
//  Created by Khumar Girdhar on 06/05/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var numberOfBalls = 5 {
        didSet {
            numberOfBallsLabel.text = "Balls left: \(numberOfBalls)"
        }
    }
    var numberOfBallsLabel: SKLabelNode!
    var balls = ["ballRed","ballGreen","ballBlue","ballCyan","ballYellow","ballGrey","ballPurple"]
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        numberOfBallsLabel = SKLabelNode(fontNamed: "Chalkduster")
        numberOfBallsLabel.text = "Balls left: 5"
        numberOfBallsLabel.horizontalAlignmentMode = .right
        numberOfBallsLabel.position = CGPoint(x: 980, y: 650)
        addChild(numberOfBallsLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 138, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()                 //toggle() does -> editingMode = !editingMode
        } else {
            if editingMode {
                //create a box with random size and random color
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
                box.name = "box"
                
            } else {
                let ball = SKSpriteNode(imageNamed: balls.randomElement() ?? "ballRed")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
                ball.physicsBody?.restitution = 0.4         //restitution is bounciness
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = CGPoint(x: location.x, y: 700)  //forcing new balls to fall from top
                ball.name = "ball"
                addChild(ball)
            }
        }
    }
    
    func makeBouncer(at Position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2.0)
        bouncer.position = Position
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
        
    }
    
    func makeSlot(at Position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = Position
        slotGlow.position = Position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)      //pi is 180 degrees
        let spinForever = SKAction.repeatForever(spin)     //to repeat the spin action forever
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            if numberOfBalls <= 0 {
                numberOfBalls = 1
            } else {
                numberOfBalls += 1
            }
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            numberOfBalls -= 1
        }
        
//challenge3
        if numberOfBalls <= 0 {
            if object.name == "box" {
                destroy(ball: object)
            }
        }
    }
    
    func destroy(ball: SKNode) {
        
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()                     //To remove a node from the game
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
 //challenge 3
        if numberOfBalls >= 5 {
            if nodeA.name == "box" {
                collision(between: nodeB, object: nodeA)
            } else if nodeB.name == "box" {
                collision(between: nodeA, object: nodeB)
            }
        }
    }
    
}
