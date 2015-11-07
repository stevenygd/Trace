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
    var gameSpeed = 20.0
    
    var balls = [(SKNode, SKNode)]()
    
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
                                        
                                        let line : SKNode = drawLine(s, e:e).0;
                                        let ball1 = drawLine(s, e:e).1;
                                        let ball2 = drawLine(s, e:e).2;
                                        
                                        
                                        nodesArray.append(line);
//                                        if (balls.count == 0) {
//                                            balls.append(ball1)
//                                            balls.append(ball2)
//                                        } else {
//                                            balls.append(ball2)
//                                        }
                                        balls.append((ball1, ball2))
                                        
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
        
        drawLinesAndBallsOffCanvas(nodesArray, balls: self.balls, duration: gameSpeed);
    }
    
    /**
     * Find a place off canvase to draw the lines
     * And move these lines up in constant speed
     */
    private func drawLinesAndBallsOffCanvas(nodes:[SKNode], balls:[(SKNode, SKNode)], duration:NSTimeInterval){
        let moveNodeUp = SKAction.moveByX(CGFloat(0.0), y: CGFloat(3000.0), duration: duration);
        
        for line:SKNode in nodes {
            line.position = CGPointMake(line.position.x, line.position.y - screenHeight);
            self.addChild(line);
            line.runAction(moveNodeUp, completion: { () -> Void in
                // clean up the nodes
                line.removeFromParent();
            })
        }
        
        for (ball1, ball2) in balls {
            ball1.position = CGPointMake(ball1.position.x, ball1.position.y - screenHeight)
            ball2.position = CGPointMake(ball2.position.x, ball2.position.y - screenHeight)
            self.addChild(ball1)
            self.addChild(ball2)
            ball1.runAction(moveNodeUp, completion: { () -> Void in
                // clean up the nodes
                ball1.removeFromParent();
            })
            ball2.runAction(moveNodeUp, completion: { () -> Void in
                // clean up the nodes
                ball2.removeFromParent();
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
     * @return the second one is the node for the s ball, the
     */
    private func drawLine(s: CGPoint, e: CGPoint) -> (SKShapeNode, SKShapeNode, SKShapeNode) {
        
        let restrictedHeight = resHeightRatio * screenHeight;
        let restrictedWidth  = resWidthRatio  * screenWidth;
        
        let line: SKShapeNode = SKShapeNode();
        let pathToDraw : CGMutablePathRef = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, nil, s.x * restrictedWidth, s.y * restrictedHeight)
        CGPathAddLineToPoint(pathToDraw, nil, e.x * restrictedWidth, e.y * restrictedHeight);
        line.path = pathToDraw;
        
        // offset to center
        line.position = CGPointMake(line.position.x + (0.5 - 0.5 * resWidthRatio)  * screenWidth,
                                    line.position.y + (0.5 - 0.5 * resHeightRatio) * screenHeight);
        
        let ball1 = SKShapeNode(circleOfRadius: 10);
        ball1.position = CGPointMake(s.x * restrictedWidth + (0.5 - 0.5 * resWidthRatio)  * screenWidth, s.y * restrictedHeight + (0.5 - 0.5 * resHeightRatio) * screenHeight)
        ball1.strokeColor = SKColor.whiteColor()
        ball1.fillColor = SKColor.whiteColor()
        
        let ball2 = SKShapeNode(circleOfRadius: 10);
        ball2.position = CGPointMake(e.x * restrictedWidth + (0.5 - 0.5 * resWidthRatio)  * screenWidth, e.y * restrictedHeight + (0.5 - 0.5 * resHeightRatio) * screenHeight)
        ball2.strokeColor = SKColor.whiteColor()
        ball2.fillColor = SKColor.whiteColor()

        
        return (line, ball1, ball2);
    }
    
    // the function that will be called when the player loses the game
    private func gameOver(){
        let transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
        let gameOverScene:SKScene = GameOverScene(size: self.size)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
