//
//  GameViewController.swift
//  Trace
//
//  Created by Grendel Yang on 11/7/15.
//  Copyright (c) 2015 Grendel Yang. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    let pan : UIPanGestureRecognizer = UIPanGestureRecognizer();
    
    var scene : GameScene? = GameScene(fileNamed:"GameScene");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.scene != nil) {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene!.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            // set up the pan gesture recognizer
//            pan.addTarget(self, action: "panOnView:")
//            self.view.addGestureRecognizer(pan);
        }
        

    }
    
//    func panOnView(sender:UIPanGestureRecognizer){
//        switch sender.state {
//        case UIGestureRecognizerState.Possible :
//            print("possible");
//        case UIGestureRecognizerState.Began :
//            print("began");
//            scene!.gameStart();
//            break;
//        case UIGestureRecognizerState.Changed:
//            print("changed %@", sender.locationInView(self.view));
//            break;
//        case UIGestureRecognizerState.Ended:
//            print("ended");
//            // end game
//            scene!.gameOver();
//            break;
//            
//        case UIGestureRecognizerState.Cancelled:
//            print("canceled");
//            // end game
//            scene!.gameOver();
//            break;
//        case UIGestureRecognizerState.Failed:
//            print("failed");
//            // end game
//            scene!.gameOver();
//            break;
//        case UIGestureRecognizerState.Recognized:
//            print("recognized");
//            break;
//        }
//    }
    
    override func viewWillLayoutSubviews() {
        
        let bgmURL:NSURL = NSBundle.mainBundle().URLForResource("bgmusic", withExtension: "mp3")!
        backgroundMusicPlayer = try! AVAudioPlayer(contentsOfURL: bgmURL)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        let skView:SKView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let scene:SKScene = GameScene(size: skView.bounds.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(scene)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
