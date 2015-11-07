//
//  GameScene.swift
//  Trace
//
//  Created by Grendel Yang on 11/7/15.
//  Copyright (c) 2015 Grendel Yang. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let screenWidth   = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        // load game data
        if let path = NSBundle.mainBundle().pathForResource("scene", ofType:"dat") {
            if let data:NSData = NSFileManager.defaultManager().contentsAtPath(path) {
                do{
                    let parsedObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data,
                        options: NSJSONReadingOptions.AllowFragments)
                    print(parsedObject);
                } catch is NSError {
                    print("Something is wrong");
                }
            }else{
                print("GOT NOTHING");
            }
        }else{
            print("get no path");
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {

            let startPoint  : CGPoint = CGPointMake(10, 10);
            let endPoint    : CGPoint = CGPointMake(0.5, 0.5);
            let yourline: SKShapeNode = drawLine(startPoint, e: endPoint);
            
            yourline.xScale = 1
            yourline.yScale = 1
            
            yourline.position = touch.locationInNode(self)

            NSLog("%0.2f, %0.2f", touch.locationInView(self.view).x, touch.locationInView(self.view).y)
            NSLog("%0.2f, %0.2f", touch.locationInNode(self).x, touch.locationInNode(self).y)
            
            self.addChild(yourline);
        }
    }
   
    /**
     * [pre] s, e lays inside [0,0]<->[1,1]
     */
    private func drawLine(s: CGPoint, e: CGPoint) -> SKShapeNode {
        let line: SKShapeNode = SKShapeNode();
        let pathToDraw : CGMutablePathRef = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, nil, s.x * screenWidth, s.y * screenHeight)
        CGPathAddLineToPoint(pathToDraw, nil, e.x * screenWidth, e.y * screenHeight);
        line.path = pathToDraw;

        return line;
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
