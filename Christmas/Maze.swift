//
//  Maze.swift
//  Christmas
//
//  Created by Yana  on 2020-11-08.
//  Copyright © 2020 Yana . All rights reserved.
//

import SpriteKit
import CoreMotion

class Maze: SKScene, SKPhysicsContactDelegate{
    
    private let manager = CMMotionManager()
    private var santa = SKSpriteNode()
    private var endNode = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        santa = self.childNode(withName: "Santa") as! SKSpriteNode
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!) * 10, dy: CGFloat((data?.acceleration.y)!) * 10)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "Present") {
            hideScene()
        }
    }
    
    func hideScene () {
        let reveal = SKTransition.doorway(withDuration: 1)
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "Hide") {
                scene.scaleMode = .aspectFill
                    view.presentScene(scene, transition: reveal)
                }
            view.ignoresSiblingOrder = true
        }
    }
    
    
    
}
