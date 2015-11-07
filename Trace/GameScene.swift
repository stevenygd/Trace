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
    let resWidthRatio = CGFloat(0.8);
    let resHeightRatio = CGFloat(0.8);
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        if let path = NSBundle.mainBundle().pathForResource("scene", ofType:"dat") {
            renderFromFile(path);
        }
        
    }
    
    // Render the next canvas from file
    private func renderFromFile(path:String){
        // load game data
        var nodesArray : [SKNode] = [];
        
        if let data:NSData = NSFileManager.defaultManager().contentsAtPath(path) {
            if let parsedObject: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments){
                    if let pDict:NSArray = parsedObject as? NSArray{
                        for obj in pDict{
                            if let objDict:NSDictionary = obj as? NSDictionary {
                                if let sArray : NSArray = objDict["s"] as? NSArray {
                                    if let eArray : NSArray = objDict["e"] as? NSArray {
                                        
                                        let s:CGPoint = CGPointMake(
                                            CGFloat(sArray[0] as! NSNumber),
                                            CGFloat(sArray[1] as! NSNumber)
                                        );
                                        let e:CGPoint = CGPointMake(
                                            CGFloat(eArray[0] as! NSNumber),
                                            CGFloat(eArray[1] as! NSNumber)
                                        );
                                        
                                        let line : SKNode = drawLine(s, e:e);
                                        nodesArray.append(line);
                                    }
                                }
                            }
                        }
                    }
            }else{
                print("something is wrong");
            }
        }else{
            print("GOT NOTHING");
        }
        
        drawLinesOffCanvas(nodesArray, duration: 10.0);
    }
    
    /**
     * Find a place off canvase to draw the lines
     * And move these lines up in constant speed
     */
    private func drawLinesOffCanvas(nodes:[SKNode], duration:NSTimeInterval){
        let moveNodeUp = SKAction.moveByX(CGFloat(0.0), y: CGFloat(3000.0), duration: duration);
        
        for line:SKNode in nodes {
            line.position = CGPointMake(line.position.x, line.position.y - screenHeight);
            self.addChild(line);
            line.runAction(moveNodeUp, completion: { () -> Void in
                // clean up the nodes
                line.removeFromParent();
            })
        }
    }
    
    /* Called when a touch begins */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // dones't support multi touch
        if (touches.count != 1){
            gameOver();
            return;
        }
        
        print(event);
        for touch:UITouch in touches {
            print(touch);
        }
    }
   
    /**
     * [pre] s, e lays inside [0,0]<->[1,1]
     */
    private func drawLine(s: CGPoint, e: CGPoint) -> SKShapeNode {
        
        let restrictedHeight = resHeightRatio * screenHeight;
        let restrictedWidth  = resWidthRatio  * screenWidth;
        
        let line: SKShapeNode = SKShapeNode();
        let pathToDraw : CGMutablePathRef = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, nil, s.x * restrictedWidth, s.y * restrictedHeight)
        CGPathAddLineToPoint(pathToDraw, nil, e.x * restrictedWidth, e.y * restrictedHeight);
        line.path = pathToDraw;
        
        // offset to center
        line.position = CGPointMake(line.position.x + (0.5 - 0.5 * resWidthRatio)  * screenWidth,
                                    line.position.x + (0.5 - 0.5 * resHeightRatio) * screenHeight);
        

        return line;
    }
    
    // the function that will be called when the player loses the game
    private func gameOver(){
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
