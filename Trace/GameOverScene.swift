//
//  GameOverScene.swift
//  Trace
//
//  Created by Mengyang Shi on 11/7/15.
//  Copyright © 2015 Grendel Yang. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size:size)
        self.backgroundColor = SKColor.whiteColor()
        
        var message:NSString = NSString()
        
        message = "Game Over"
        
        
        let label:SKLabelNode = SKLabelNode(fontNamed: "DamascusBold")
        label.text = message as String
        label.fontColor = SKColor.blackColor()
        label.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        let restartLabel:SKLabelNode = SKLabelNode(fontNamed: "DamascusBold")
        restartLabel.text = "5 seconds to restart!"
        restartLabel.fontColor = SKColor.blackColor()
        restartLabel.position = CGPointMake(self.size.width/2, self.size.height/2-label.frame.height)
        
        self.addChild(label)
        self.addChild(restartLabel)
        
        self.runAction(SKAction.sequence([SKAction.waitForDuration(5.0), SKAction.runBlock({
            let transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
            let scene:SKScene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        })]))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}