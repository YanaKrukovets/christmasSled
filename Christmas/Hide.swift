//
//  Hide.swift
//  Christmas
//
//  Created by Yana  on 2020-11-08.
//  Copyright © 2020 Yana . All rights reserved.
//

import SpriteKit
import GameplayKit

class Hide: SKScene {
    
    private var santa: SKSpriteNode! = SKSpriteNode()
    private var safe: SKLabelNode!
    private var happy: SKLabelNode!
    private var share: SKLabelNode!
    private var sleigh: SKNode!
    private var backroundMove: Bool = false
    private var again: Bool = true
    
    override func didMove(to view: SKView) {
        sleigh = self.childNode(withName: "sleigh")
        safe = self.childNode(withName: "safe") as! SKLabelNode
        happy = self.childNode(withName: "happy") as! SKLabelNode
        share = self.childNode(withName: "shareLabel") as! SKLabelNode
        safe.alpha = 0
        happy.alpha = 0
        share.alpha = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
                
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if (touchedNode.name == "sleigh") {
            sleigh.run(SKAction.scale(by: 2, duration: 1), completion: {
                self.childNode(withName: "message")?.run(SKAction.unhide())
                self.safe.run(SKAction.fadeIn(withDuration: 1))
                self.happy.run(SKAction.fadeIn(withDuration: 1))
                self.share.run(SKAction.fadeIn(withDuration: 1))
                self.childNode(withName: "Insta")?.run(SKAction.unhide())
            })
        }
        
        if (touchedNode.name == "Insta" || touchedNode.name == "shareLabel") {
            shareToInstaStories()
        }

    }
    
    func shareToInstaStories() {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let image = UIImage(named: "Share") else { return }
                guard let imageData = image.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                   UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
               } else {
                   print("User doesn't have instagram on their device.")
               }
           }
       }
}

