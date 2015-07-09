//
//  GameViewController.swift
//  speaker_motion
//
//  Created by Bridget Johnson on 19/06/15.
//  Copyright (c) 2015 bdj. All rights reserved.
//

import UIKit
import SpriteKit



extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
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
   
   var manual_IP: String = "" {
      didSet {
        
      }
   }
   
   var manual_Port: String = "" {
      didSet {
         
      }
   }


   override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews() 

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.frame = self.view.frame
         
            skView.showsFPS = false
            skView.showsNodeCount = false
         
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
        
         scene.size = skView.bounds.size
         scene.anchorPoint = CGPointMake(0.0, 0.0)
            scene.scaleMode = SKSceneScaleMode.AspectFill
            scene.manual_IP = manual_IP
            scene.manual_Port = manual_Port
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
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
