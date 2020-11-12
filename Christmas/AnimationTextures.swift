//
//  AnimationTextures.swift
//  Christmas
//
//  Created by Yana  on 2020-11-04.
//  Copyright © 2020 Yana . All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimationTextures: SKScene {
    
    public var person = SKSpriteNode()
    public var personWalking: [SKTexture] = []
    
    func buildPerson (name: String, position: CGPoint) -> SKSpriteNode {
        let gnomeAtlas = SKTextureAtlas(named: name)
        var walkFrames: [SKTexture] = []
        let numImages = gnomeAtlas.textureNames.count
        for i in 1...numImages {
            let gnomeTexture = "\(name)\(i)"
            walkFrames.append(gnomeAtlas.textureNamed(gnomeTexture))
        }
        personWalking = walkFrames
        let firstFrameTexture = personWalking[0]
        person = SKSpriteNode(texture: firstFrameTexture)
        person.anchorPoint = CGPoint(x: 0.5, y: 0)
        person.position = position
        person.zPosition = 5
        return person
    }
    
    func getPerson () -> [SKTexture] {
        return personWalking
    }
    
    func animatePerson (animatePerson: SKSpriteNode) {
        animatePerson.run(SKAction.repeatForever(SKAction.animate(with: personWalking,
               timePerFrame: 0.12, resize: false, restore: true)))
    }
}


