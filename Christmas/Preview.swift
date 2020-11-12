//
//  Preview.swift
//  Christmas
//
//  Created by Yana  on 2020-11-11.
//  Copyright © 2020 Yana . All rights reserved.
//

import SpriteKit
import GameplayKit

class Preview: SKScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
        return
    }
            
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    
        if (touchedNode.name == "Play") {
            if let view = self.view as! SKView? {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                          view.presentScene(scene)
                    }
                    view.ignoresSiblingOrder = true
                }
        }
}
}
