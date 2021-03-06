//
//  GameScene.swift
//  Trace
//
//  Created by Grendel Yang on 11/7/15.
//  Copyright (c) 2015 Grendel Yang. All rights reserved.
//

import SpriteKit

enum SceneState {
    case ReadyToBegin
    case OnProgress
    case GameOver
}


class GameScene: SKScene {

    var state : SceneState = SceneState.ReadyToBegin;
    
    let screenWidth   = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let resWidthRatio = CGFloat(0.8);
    let resHeightRatio = CGFloat(0.8);
    var gameSpeed = 20.0
    var lineCap = 4
    var fingerLocation:CGPoint = CGPointMake(0, 0)
    var scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    var balls = [(SKNode, SKNode)]()
    var lines : [SKNode] = [];
    var allLines:[SKNode] = [];
    var allBalls:[SKNode] = [];
    
    var score = 0;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Trace!";
        myLabel.fontSize = 45;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        
        scoreLabel.text = "score: " + String(score)
        scoreLabel.fontSize = 20;
        scoreLabel.position = CGPoint(x: 50, y: self.frame.height - 20);
        self.addChild(scoreLabel)
        
        gameStart()
    }
    
    
    
    private func generateRandomLinesAndBalls(lineCap:NSInteger){
        var lastE:CGPoint = CGPointMake(0, 0)
        var lastS:CGPoint = CGPointMake(0, 0)
        for i in 1...lineCap {
            var s:CGPoint
            var e:CGPoint
            if i == lineCap {
                s = lastE
                e = CGPointMake(0.5, 0)
            } else if i == 1 {
                s = CGPointMake(0.5, 1)
                e = CGPointMake(randomCGFloat(), randomCGFloat())
            } else {
                s = lastE
                e = CGPointMake(randomCGFloat(), randomCGFloat())
                var dotProduct = (e.x - s.x) * (lastE.x - lastS.x) + (e.y - s.y) * (lastE.y - lastS.y)
                var angle = acos(dotProduct / (lengthOf(s, e: e) * lengthOf(lastS, e: lastE)))
                //change here to limit the range of angle 
                while angle > 1.14 || angle < 1.04 {
                    e = CGPointMake(randomCGFloat(), randomCGFloat())
                    dotProduct = (e.x - s.x) * (lastE.x - lastS.x) + (e.y - s.y) * (lastE.y - lastS.y)
                    angle = acos(dotProduct / (lengthOf(s, e: e) * lengthOf(lastS, e: lastE)))
                }
                print(angle)
            }
            lastE = e
            lastS = s
            let line : SKNode = drawLine(s, e:e).0;
            let ball1 = drawLine(s, e:e).1;
            let ball2 = drawLine(s, e:e).2;
            lines.append(line);
            balls.append((ball1, ball2))
            allLines.append(line)
            allBalls.append(ball1)
            allBalls.append(ball2)
        }
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    func lengthOf(s: CGPoint, e: CGPoint) -> CGFloat {
        let xDiff = e.x - s.x
        let yDiff = e.y - s.y
        return sqrt(xDiff * xDiff + yDiff * yDiff)
    }
    
    /**
     * Find a place off canvase to draw the lines
     * And move these lines up in constant speed
     */
    private func drawLinesAndBallsOffCanvas(nodes:[SKNode], balls:[(SKNode, SKNode)], duration:NSTimeInterval){
        // clean up
        lines.removeAll()
        self.balls.removeAll()

        let moveNodeUp = SKAction.moveByX(CGFloat(0.0), y: CGFloat(3 * screenHeight), duration: duration);
        
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
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        // dones't support multi touch
//        if (touches.count != 1){
//            gameOver();
//            return;
//        }
//        
//        print(event);
//        for touch:UITouch in touches {
//            print(touch);
//        }
//    }
   
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
        line.lineWidth = 20
        
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
    func gameOver(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.integerForKey("highest score") < score || defaults.integerForKey("highest score") == 0) {
            defaults.setInteger(score, forKey: "highest score")
        }
        let transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.5)
        let gameOverScene:SKScene = GameOverScene(size: self.size, won:true, score:self.score)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
    
    
    // start or restart t
    func gameStart(){
        // TODO
        self.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({
                    self.generateRandomLinesAndBalls(self.lineCap);
                    self.drawLinesAndBallsOffCanvas(self.lines, balls: self.balls, duration: self.gameSpeed);
                }),
                SKAction.waitForDuration(gameSpeed / (3 / 0.8))
                ])
            ))
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch = (touches.first! as UITouch)
        fingerLocation = touch.locationInNode(self)
        print(fingerLocation)
        
        let node = nodeAtPoint(fingerLocation)
        
        if !allLines.contains(node) && !allBalls.contains(node) {
            gameOver()
            print("end")
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch = (touches.first! as UITouch)
        fingerLocation = touch.locationInNode(scene!)
        print(fingerLocation)
        
        let node = nodeAtPoint(fingerLocation)
        
        if !allLines.contains(node) && !allBalls.contains(node) {
            gameOver()
            print("end")
        }
        
        score+=1;
        scoreLabel.text = "score: " + String(score)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        gameOver()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
