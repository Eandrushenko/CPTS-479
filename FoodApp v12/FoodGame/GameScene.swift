//
//  GameScene.swift
//  FoodGame
//
//  Created by Elijah Andrushenko on 4/22/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var BagNode: SKSpriteNode!
    var StartNode: SKLabelNode!
    var ScoreNode: SKLabelNode!
    var MissNode: SKLabelNode!
    var GameNode = SKLabelNode()
    var FinalNode = SKLabelNode()
    
    var gameRunning = false
    var score : Int = 0
    var lives : Int = 3
    
    var images: [String] = ["cake.png", "pizza.png", "burger.png", "steak.png", "pie.png"]
    
    var sceneHeight: Int!
    var sceneWidth: Int!
    
    var timer : Timer?
    
    override func didMove(to view: SKView) {
        let screenPhysicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        screenPhysicsBody.friction = 0.0
        screenPhysicsBody.categoryBitMask = 0b0100
        screenPhysicsBody.contactTestBitMask = 0b0001
        self.physicsBody = screenPhysicsBody
        self.name = "Wall"
        
        self.physicsWorld.contactDelegate = self
        
        StartNode = self.childNode(withName: "Start") as? SKLabelNode
        ScoreNode = self.childNode(withName: "Score") as? SKLabelNode
        MissNode = self.childNode(withName: "Miss") as? SKLabelNode
        
        sceneHeight = Int(self.size.height)
        sceneWidth = Int(self.size.width)
        
        spawnBag()
        finalScore()
    }
    
    func finalScore() {
        GameNode.name = "Game"
        GameNode.text = "GAME OVER"
        GameNode.fontSize = 64
        GameNode.isHidden = true
        FinalNode.name = "Final"
        FinalNode.text = "Your Score: \(score)"
        FinalNode.fontSize = 48
        FinalNode.position.y = -60
        FinalNode.isHidden = true
        self.addChild(GameNode)
        self.addChild(FinalNode)
    }
    
    func spawnBag() {
        BagNode = SKSpriteNode(imageNamed: "bag.png")
        BagNode.name = "Bag"
        BagNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 128, height: 90))
        BagNode.physicsBody?.affectedByGravity = false
        BagNode.physicsBody?.friction = 0.0
        BagNode.physicsBody?.restitution = 1.0
        BagNode.physicsBody?.linearDamping = 0.0
        BagNode.physicsBody?.pinned = false
        BagNode.physicsBody?.isDynamic = true
        BagNode.physicsBody?.collisionBitMask = 0b0000
        BagNode.physicsBody?.contactTestBitMask = 0b0001
        BagNode.position.x = 0.0
        BagNode.position.y = -620.0
        BagNode.isHidden = true
        self.addChild(BagNode)
    }
    
    @objc func spawnFood() {
        let FoodImage: String = images[Int.random(in: 0...4)]
        let FoodItemNode: SKSpriteNode!
        FoodItemNode = SKSpriteNode(imageNamed: FoodImage)
        FoodItemNode.name = "FoodItem"
        FoodItemNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 128, height: 128))
        FoodItemNode.physicsBody?.affectedByGravity = true
        FoodItemNode.physicsBody?.friction = 0.0
        FoodItemNode.physicsBody?.restitution = 1.0
        FoodItemNode.physicsBody?.linearDamping = 0.0
        FoodItemNode.physicsBody?.pinned = false
        FoodItemNode.physicsBody?.isDynamic = true
        FoodItemNode.physicsBody?.collisionBitMask = 0b0000
        FoodItemNode.physicsBody?.contactTestBitMask = 0b0001
        FoodItemNode.position.x = CGFloat(Int.random(in: (-(sceneWidth/2)+128)...((sceneWidth/2)-128)))
        FoodItemNode.position.y = CGFloat(Int.random(in: 0...((sceneHeight/2)-128)))
        self.addChild(FoodItemNode)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        print("Contact: \(nodeA.name ?? "?") with \(nodeB.name ?? "?")")
        if (nodeA.name == "Wall" && nodeB.name == "FoodItem") || (nodeB.name == "Wall" && nodeA.name == "FoodItem") {
            lives = lives - 1
            MissNode.text = "Misses Left: \(lives)"
            if lives < 1 {
                EndGame()
            }
        }
        if (nodeA.name == "Bag" && nodeB.name == "FoodItem") || (nodeB.name == "Bag" && nodeA.name == "FoodItem") {
            score = score + 1
            ScoreNode.text = "Score: \(score)"
        }
        if nodeB.name == "FoodItem" || nodeA.name == "FoodItem" {
            nodeB.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            let nodeArray = nodes(at: point)
            for node in nodeArray {
                print("tapped \(node.name!)")
                BagNode?.position.x = point.x
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            let nodeArray = nodes(at: point)
            for node in nodeArray {
                if node.name == "Bag" {
                    BagNode?.position.x = point.x
                }
            }
        }
    }
    
    func startTimer() {
        guard timer == nil else {return}
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(spawnFood), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startGame() {
        self.isPaused = false
        StartNode?.isHidden = true
        GameNode.isHidden = true
        FinalNode.isHidden = true
        BagNode?.position.x = 0
        BagNode?.isHidden = false
        lives = 3
        MissNode.text = "Misses Left: \(lives)"
        score = 0
        ScoreNode.text = "Score: \(score)"
        BagNode.isHidden = false
        startTimer()
    }
    
    func EndGame() {
        self.isPaused = true
        StartNode?.isHidden = false
        BagNode.isHidden = true
        GameNode.isHidden = false
        FinalNode.text = "Your Score: \(score)"
        FinalNode.isHidden = false
        stopTimer()
        for child in self.children {
            if child.name == "FoodItem" {
                child.removeFromParent()
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            let nodeArray = nodes(at: point)
            for node in nodeArray {
                if node.name == "Start" {
                    startGame()
                    }
                }
            }
        }
}
