//
//  Jump.swift
//  Christmas
//
//  Created by Yana  on 2020-11-07.
//  Copyright © 2020 Yana . All rights reserved.
//

import SpriteKit
import GameplayKit

class Jump: SKScene, SKPhysicsContactDelegate {
    
    private var santa: SKSpriteNode! = SKSpriteNode()
    private var gameOver: SKLabelNode!
    private var tryAgain: SKLabelNode!
    private var backround: SKNode!
    private var backroundMove: Bool = false
    private var again: Bool = true
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        santa.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 0.4))
    }
    
    func moveBackround () {
        backround.run(SKAction.move(by: CGVector(dx: -2900, dy: 0), duration: 15), completion: {
            self.mazeScene()
        })
        santa.physicsBody?.affectedByGravity = true
        santa.physicsBody?.allowsRotation = true
        backroundMove = true
    }
    
    func mazeScene () {
        let reveal = SKTransition.doorway(withDuration: 1)
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "Maze") {
                scene.scaleMode = .aspectFit
                    view.presentScene(scene, transition: reveal)
                }
            view.ignoresSiblingOrder = true
        }
    }
    
    override func didMove(to view: SKView) {
        backround = self.childNode(withName: "BAckground")
        santa = self.childNode(withName: "santa") as! SKSpriteNode
        gameOver = self.childNode(withName: "GameOver") as! SKLabelNode
        tryAgain = self.childNode(withName: "TryAgain") as! SKLabelNode
        gameOver.alpha = 0
        tryAgain.alpha = 0
        self.physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        stopGame()
    }
    
    func stopGame () {
        backround.removeAllActions()
        gameOver.run(SKAction.fadeIn(withDuration: 1), completion: {
            self.tryAgain.alpha = 1
        })
        backroundMove = false
        again = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
                
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
         
        if (!backroundMove && again) {
            santa.physicsBody?.pinned = false
            moveBackround()
            again = false
        }
        
        if (touchedNode.name == "TryAgain") {
            gameOver.run(SKAction.fadeOut(withDuration: 1))
            gameOver.alpha = 0
            tryAgain.run(SKAction.fadeOut(withDuration: 1))
            tryAgain.alpha = 0
            backround.position = CGPoint(x: -self.frame.width/2, y: 0.8)
            santa.position = CGPoint(x: -153, y: 11)
            santa.physicsBody?.allowsRotation = false
            santa.zRotation = 0
            santa.physicsBody?.pinned = true
            santa.physicsBody?.affectedByGravity = false
            again = true
        }

    }
}
