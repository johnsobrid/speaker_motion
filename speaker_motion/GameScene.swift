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
  

   var isfingerOnBall: [Bool] = [false,false,false,false]
   
   var newManager = OSCManager()
   var newOutPort = OSCOutPort()
   
   var interArray: [SKSpriteNode] = []
   var ballArray: [InteractionBall] = []
   
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      
      
      newOutPort = newManager.createNewOutputToAddress(manualIP, atPort:Int32(manualPort), withLabel: "OutPort")
      
           initInterZones()
           initBalls()
        }

   func initInterZones() {
      
      for i in 0...4 {
         let InterZone = SKSpriteNode(imageNamed: "InteractionArea")
         
         InterZone.size = CGSizeMake(self.size.width*0.280, self.size.height/2)
         InterZone.anchorPoint = CGPointZero

         if (i == 0) {
         InterZone.position = CGPointMake(self.size.width * 0.220, self.size.height/2)
            var newString = "zoneName\(i)"
            InterZone.name = newString
            addChild(InterZone)

         } else if (i == 1) {
            InterZone.position = CGPointMake(self.size.width/2, self.size.height/2)
            var newString = "zoneName\(i)"
            InterZone.name = newString
            addChild(InterZone)

         } else if (i == 2) {
            InterZone.position = CGPointMake(self.size.width/2, 0.0)
            var newString = "zoneName\(i)"
            InterZone.name = newString
            addChild(InterZone)

         } else if (i == 3) {
            InterZone.position = CGPointMake(self.size.width * 0.220, 0.0)
            var newString = "zoneName\(i)"
            InterZone.name = newString
            addChild(InterZone)
         }
        
         interArray.append(InterZone)
      }
      
   }

func initBalls() {
   for i in 0...3 {
      let ball: InteractionBall = InteractionBall()
      ball.position = CGPointMake(CGRectGetMidX(interArray[i].frame) , CGRectGetMidY(interArray[i].frame))
      ball.zPosition = 2
      var newString = "ballName\(i)"
      ball.name = newString
      addChild(ball)
      ballArray.append(ball)
   }

}
    
   
      override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
         var touch = touches.first as! UITouch
         var touchLocation = touch.locationInNode(self)

         
         let touchedNode = self.nodeAtPoint(touchLocation)
         
         if let name = touchedNode.name
         {
            for i in 0...3 {
            var newString = "ballName\(i)"
            if name == newString
            {
              isfingerOnBall[i] = true
            }
            }
         }
   }
   override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
      // 1. Check whether user touched the ball
      for i in 0...3 {
      if isfingerOnBall[i] {
         // 2. Get touch location
         var touch = touches.first as! UITouch
         var touchLocation = touch.locationInNode(self)
         var previousLocation = touch.previousLocationInNode(self)
         
         // 3. Get node for ball
         if let ball = childNodeWithName("ballName\(i)") as? SKSpriteNode {
         // 4. Calculate new position along x for ball
         var ballX = ball.position.x + (touchLocation.x - previousLocation.x)
         var ballY = ball.position.y + (touchLocation.y - previousLocation.y)
            
        //  5. Limit x and y so that ball won't leave its zone
            //if your in the left two zones restrict x accordingly
            if (i == 0 || i == 3) {
               
               if (ballX < self.frame.origin.x)
               {
                  ballX = frame.origin.x + ball.size.width/2
               }
               else if (ballX > frame.size.width/2) {
                  ballX = frame.size.width/2 - ball.size.width/2
               }
            }
            //if you're in the right two zones limit x
            if (i == 1 || i == 2) {
               
               if (ballX < frame.size.width/2)
               {
                  ballX = frame.size.width/2 + ball.size.width/2
               }
               else if (ballX > frame.size.width) {
                  ballX = frame.size.width - ball.size.width/2
               }
            }
            
            //if you are in the top two zones limit y
            if (i == 0 || i == 1) {
               
               if (ballY < self.frame.size.height/2)
               {
                  ballY = self.frame.size.height/2 - ball.size.height/2
               }
               else if (ballY > frame.size.height) {
                  ballY = frame.size.height - ball.size.height/2
               }
            }
            if (i == 2 || i == 3) {
               
               if (ballY < self.frame.origin.y)
               {
                  ballY = self.frame.origin.y/2 + ball.size.height/2
               }
               else if (ballY > frame.size.height/2) {
                  ballY = frame.size.height/2 + ball.size.height/2
               }
            }
            
         // 6. Update paddle position
         ball.position = CGPointMake(ballX, ballY)
         sendOSC(Float(ball.position.x), yPos: Float(ball.position.y))
         }
         }
      }
   }
   
   override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
      for i in 0...3 {
         if isfingerOnBall[i]
         {
            isfingerOnBall[i] = false
         }
      }
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
