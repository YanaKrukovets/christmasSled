//
//  Hole.swift
//  Christmas
//
//  Created by Yana  on 2020-11-06.
//  Copyright © 2020 Yana . All rights reserved.
//

import SpriteKit
import GameplayKit

class Hole: SKScene {
    
    private var santaInHole: SKSpriteNode = SKSpriteNode()
    private var jumpSanta: SKSpriteNode = SKSpriteNode()
    private var anime: AnimationTextures = AnimationTextures()
    
    override func didMove(to view: SKView) {
        moveSanta()
        self.childNode(withName: "Candy")?.run(SKAction.move(to: CGPoint(x: -205, y: -1440), duration: 9))
        self.childNode(withName: "Candy1")?.run(SKAction.move(to: CGPoint(x: -205, y: -1440), duration: 11))
        self.childNode(withName: "Pressent")?.run(SKAction.move(to: CGPoint(x: -205, y: -1440), duration: 9))
        self.childNode(withName: "Pressent1")?.run(SKAction.move(to: CGPoint(x: -205, y: -1440), duration: 11))
        self.childNode(withName: "Deer")?.run(SKAction.move(to: CGPoint(x: 350, y: -1440), duration: 15))
         self.childNode(withName: "SnowMan")?.run(SKAction.move(to: CGPoint(x: -205, y: -1440), duration: 15))
    }
    
    func santaSitting () {
        self.santaInHole.removeAllActions()
        self.santaInHole.removeFromParent()
        self.childNode(withName: "SantaSit")?.run(SKAction.sequence([SKAction.unhide(), SKAction.wait(forDuration: 2.0)]), completion: {
            self.jumpSanta = self.anime.buildPerson(name: "JumpSanta", position: CGPoint(x: 0, y: -70))
            self.childNode(withName: "SantaSit")?.removeFromParent()
            self.addChild(self.jumpSanta)
            self.anime.animatePerson(animatePerson: self.jumpSanta)
            self.jumpSanta.run(SKAction.move(to: CGPoint(x: self.frame.width/2 + 20, y: 0), duration: 1), completion: {
                self.jumpScene()
            })
        })
    }
    
    func jumpScene () {
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "Jump") {
                scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                }
                view.ignoresSiblingOrder = true
            }
    }
    
    func moveSanta () {
        let move = SKAction.move(to: CGPoint(x: 0, y: 790), duration: 10)

        santaInHole = anime.buildPerson(name: "SantaInHole", position: CGPoint(x: 0, y: 0))
        self.addChild(santaInHole)
        anime.animatePerson(animatePerson: santaInHole)
        self.childNode(withName: "BackgroundHole")?.run(move, completion: {
        self.santaInHole.run(SKAction.move(to: CGPoint(x: 0, y: -70), duration: 1), completion: {
                self.santaSitting()
            })
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
                
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
         
        if (touchedNode.name == "Deer") {
            touchedNode.removeAllActions()
            magic ()
            touchedNode.removeFromParent()
        }
    }
    
    func magic () {
        if let magicParticles = SKEmitterNode(fileNamed: "Candy.sks") {
          magicParticles.position = self.childNode(withName: "Deer")?.position as! CGPoint
            self.addChild(magicParticles)
        }
    }
}
