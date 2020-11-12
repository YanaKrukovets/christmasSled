//
//  GameScene.swift
//  Christmas
//
//  Created by Yana  on 2020-11-03.
//  Copyright © 2020 Yana . All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var leftTree: [SKSpriteNode] = []
    private var rightTree: [SKSpriteNode] = []
    private var anime: AnimationTextures = AnimationTextures()
    private var gnome: SKSpriteNode = SKSpriteNode()
    private var santaWalk: SKSpriteNode = SKSpriteNode()
    private var santaToHole: SKSpriteNode = SKSpriteNode()
    private var gnomeBack: SKSpriteNode = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        let moveLeft = SKAction.move(to: CGPoint(x: -self.frame.width, y: 0), duration: 4.5)
        let moveRight = SKAction.move(to: CGPoint(x: self.frame.width, y: 0), duration: 5.5)
        createTree()
        moveTree(move: moveLeft, trees: leftTree)
        moveTree(move: moveRight, trees: rightTree)
        gnome = anime.buildPerson(name: "Gnome", position: CGPoint(x: 250, y: -150))
        self.addChild(gnome)
    }
    
    // creates trees on the first scene
    func createTree () {
        let trees = ["Tree1", "Tree2", "Tree1", "Tree2", "Tree1", "Tree2", "Tree1", "Tree2"]
        var textureTree = SKTexture()
        var treeSpriteNode = SKSpriteNode()
        var index = 0
        var position = 0
        for item in trees {
            textureTree = SKTexture(imageNamed: item)
            treeSpriteNode = SKSpriteNode(texture: textureTree)
            treeSpriteNode.zPosition = CGFloat(index) + 5.0
            position = Int(-self.frame.width/2) + (110*index)
            treeSpriteNode.position = CGPoint(x: position, y: 0)
            if (position > 0) {
                rightTree.append(treeSpriteNode)
            } else {
                leftTree.append(treeSpriteNode)
            }
            index += 1
            self.addChild(treeSpriteNode)
        }
    }
    
    //animates gnome in magic
    func animateBackGnome () {
        let santaOpenDoor = self.childNode(withName: "SantaOpenDoor")
        let santaOpenDoorPosition = CGPoint(x: 150, y: -75)
        
        self.gnomeBack.run(SKAction.scale(by: 0.8, duration: 0.3))
        self.gnomeBack.run(SKAction.animate(with: anime.getPerson(),
                                            timePerFrame: 0.3, resize: false, restore: true), completion: {
                self.gnomeBack.removeFromParent()
                self.santaWalk = self.anime.buildPerson (name: "SantaWalk", position: santaOpenDoorPosition)
                self.addChild(self.santaWalk)
                santaOpenDoor?.run(SKAction.sequence([SKAction.unhide(), SKAction.wait(forDuration: 0.5),  SKAction.hide()]), completion: {
                    self.anime.animatePerson(animatePerson: self.santaWalk)
                    self.santaWalk.run(SKAction.scale(by: 2, duration: 1.5))
                    self.santaWalk.run(SKAction.move(to: CGPoint(x: 17, y: -95), duration: 4.0),
                            completion: {
                                self.moveSantaToHole()
                    })
                })
      })
    }
    
    func moveSantaToHole () {
        self.santaWalk.removeAllActions()
        self.santaWalk.removeFromParent()
        self.santaToHole = self.anime.buildPerson (name: "SantaToHole", position: CGPoint(x: 16, y: -123))
        self.addChild(self.santaToHole)
        self.santaToHole.run(SKAction.scale(by: 0.8, duration: 0.3))
        self.santaToHole.run(SKAction.animate(with: self.anime.getPerson(),
                                              timePerFrame: 0.3, resize: false, restore: true),
                    completion: {
                        self.santaToHole.run(SKAction.hide())
                        self.holeScene()
            })
    }
    
    func holeScene () {
        if let view = self.view as! SKView? {
            let reveal = SKTransition.doorway(withDuration: 1)

                if let scene = SKScene(fileNamed: "Hole") {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene, transition: reveal)
                }
                view.ignoresSiblingOrder = true
            }
    }
    
    func moveGnome () {
        let gnomeBack = self.childNode(withName: "GnomeBack")
        
        gnome.run(SKAction.move(to: gnomeBack?.position ?? CGPoint(x: -35, y: -80), duration: 4.0), completion: {
            self.gnome.removeAllActions()
            self.gnome.removeFromParent()
            gnomeBack?.run(SKAction.unhide())
            self.magic()
            _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.removeSleigh), userInfo: nil, repeats: false) // go to the home scene after 10 seconds
        })
    }
    
    @objc func removeSleigh () {
        self.childNode(withName: "sleigh")?.run(SKAction.hide())
        self.childNode(withName: "Ellipse")?.run(SKAction.unhide())
        self.childNode(withName: "hole1")?.run(SKAction.unhide())
        self.childNode(withName: "hole2")?.run(SKAction.unhide())
        self.childNode(withName: "GnomeBack")?.run(SKAction.move(to: CGPoint(x: 20, y: -66), duration: 1.0), completion: {
            self.gnomeBack = self.anime.buildPerson (name: "GnomeBack", position: CGPoint(x: 16, y: -123))
            self.addChild(self.gnomeBack)

            self.childNode(withName: "GnomeBack")?.removeFromParent()
            self.animateBackGnome ()
        })
    }
    
    func magic () {
        if let magicParticles = SKEmitterNode(fileNamed: "Magic.sks") {
          magicParticles.position = self.childNode(withName: "GnomeBack")?.position as! CGPoint
            self.addChild(magicParticles)
        }
    }

    func moveTree (move: SKAction, trees: [SKSpriteNode]) {
        for (nodeIndex, currentNode) in trees.enumerated() {
            currentNode.run(SKAction.sequence([SKAction.wait(forDuration: TimeInterval(nodeIndex) * 0.2), move]), completion: {
                self.anime.animatePerson(animatePerson: self.gnome)
                self.moveGnome ()
            })
        }
    }
   
}
