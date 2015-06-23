//
//  GameScene.swift
//  speaker_motion
//
//  Created by Bridget Johnson on 19/06/15.
//  Copyright (c) 2015 bdj. All rights reserved.
//

import SpriteKit

public var manualIP = String()
public var manualPort = Int()

class GameScene: SKScene {
   
   var manual_IP: String = "" {
      didSet {
         manualIP = manual_IP
      }
   }
   
   var manual_Port: String = "" {
      didSet {
         manualPort = manual_Port.toInt()!
         
      }
   }

   
   let InterZone = SKSpriteNode(imageNamed: "InteractionArea")
   let ball: InteractionBall = InteractionBall()
   var isfingerOnBall = false
   
   var newManager = OSCManager()
   var newOutPort = OSCOutPort()
   
   
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      
      
      newOutPort = newManager.createNewOutputToAddress(manualIP, atPort:Int32(manualPort), withLabel: "OutPort")
      
      InterZone.size = CGSizeMake(self.size.width*0.280, self.size.height/2)
      InterZone.anchorPoint = CGPointZero
      InterZone.position = CGPointMake(self.size.width * 0.220, 0.0)
     
      InterZone.zPosition = 1
      InterZone.name = "zoneName"
      addChild(InterZone)
      
      ball.position = CGPointMake(CGRectGetMidX(InterZone.frame) , CGRectGetMidY(InterZone.frame))
      ball.zPosition = 2
      ball.name = "ballName"
      addChild(ball)
   }
    
   
      override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
         var touch = touches.first as! UITouch
         var touchLocation = touch.locationInNode(self)

         
         let touchedNode = self.nodeAtPoint(touchLocation)
         
         if let name = touchedNode.name
         {
            if name == "ballName"
            {
              isfingerOnBall = true
            }
         }
   }
   override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
      // 1. Check whether user touched the ball
      if isfingerOnBall {
         // 2. Get touch location
         var touch = touches.first as! UITouch
         var touchLocation = touch.locationInNode(self)
         var previousLocation = touch.previousLocationInNode(self)
         
         // 3. Get node for ball
         if let ball = childNodeWithName("ballName") as? SKSpriteNode {
         // 4. Calculate new position along x for ball
         var ballX = ball.position.x + (touchLocation.x - previousLocation.x)
         var ballY = ball.position.y + (touchLocation.y - previousLocation.y)
            
         // 5. Limit x and y so that ball won't leave screen to left or right
         ballX = max(ballX, ball.size.width/2)
         ballX = min(ballX, size.width/2 - ball.size.width/2)
            
         ballY = max(ballY, ball.size.height/2)
         ballY = min(ballY, InterZone.size.height - ball.size.height/2)
         // 6. Update paddle position
         ball.position = CGPointMake(ballX, ballY)
         sendOSC(Float(ballX), yPos: Float(ballY))

         }
      }
   }
   
   override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
      isfingerOnBall = false
   }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
   
   
   func sendOSC(xPos: Float, yPos: Float) {
      let newMsg: OSCMessage = OSCMessage(address: "/test")
      newMsg.addFloat(xPos)
      newMsg.addFloat(yPos)
      newOutPort.sendThisMessage(newMsg)

   }
}
