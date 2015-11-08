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
    
    init(size: CGSize, won:Bool, score:NSInteger) {
        super.init(size:size)
        self.backgroundColor = SKColor.whiteColor()
        
        var message:NSString = NSString()
        
        message = "Game Over"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let label:SKLabelNode = SKLabelNode(fontNamed: "DamascusBold")
        label.text = message as String
        label.fontColor = SKColor.blackColor()
        label.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        let restartLabel:SKLabelNode = SKLabelNode(fontNamed: "DamascusBold")
        restartLabel.text = "5 seconds to restart!"
        restartLabel.fontColor = SKColor.blackColor()
        restartLabel.position = CGPointMake(self.size.width/2, self.size.height/2-label.frame.height)
        
        let scoreLabel:SKLabelNode = SKLabelNode(fontNamed: "DamascusBold")
        scoreLabel.text = "your score: " + String(score)
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2+label.frame.height)
        
        let highLabel:SKLabelNode = SKLabelNode(fontNamed: "DamascusBold")
        highLabel.text = "highest score: " + String(defaults.integerForKey("highest score"))
        highLabel.fontColor = SKColor.blackColor()
        highLabel.position = CGPointMake(self.size.width/2, self.size.height/2+2 * label.frame.height)

        
        self.addChild(label)
        self.addChild(restartLabel)
        self.addChild(scoreLabel)
        self.addChild(highLabel)
        
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