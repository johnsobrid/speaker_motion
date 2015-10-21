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
         manualPort = Int(manual_Port)!
         
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
         InterZone.anchorPoint = CGPointZero
         InterZone.size = CGSizeMake(scene!.size.width/2, scene!.size.height/2)

         if (i == 0) {
            InterZone.position = CGPointMake(self.frame.origin.x, self.size.height/2)
            print(InterZone.position)
            let newString = "zoneName\(i)"
            InterZone.name = newString
            addChild(InterZone)

         } else if (i == 1) {
            InterZone.position = CGPointMake(self.size.width/2, self.size.height/2)
            let newString = "zoneName\(i)"
            InterZone.name = newString
            addChild(InterZone)

         } else if (i == 2) {
            InterZone.position = CGPointMake(self.size.width/2, self.frame.origin.y)
            let newString = "zoneName\(i)"
            InterZone.name = newString
            addChild(InterZone)

         } else if (i == 3) {
            InterZone.position = CGPointMake(self.frame.origin.x, self.frame.origin.y)
            let newString = "zoneName\(i)"
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
      let newString = "ballName\(i)"
      ball.name = newString
      addChild(ball)
      ballArray.append(ball)
   }

}
    
   
      override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
         let touch = touches.first! as UITouch
         let touchLocation = touch.locationInNode(self)

         
         let touchedNode = self.nodeAtPoint(touchLocation)
         
         if let name = touchedNode.name
         {
            for i in 0...3 {
            let newString = "ballName\(i)"
            if name == newString
            {
              isfingerOnBall[i] = true
            }
            }
         }
   }
   override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
      // 1. Check whether user touched the ball
      for i in 0...3 {
      if isfingerOnBall[i] {
         // 2. Get touch location
         let touch = touches.first! as UITouch
         let touchLocation = touch.locationInNode(self)
         let previousLocation = touch.previousLocationInNode(self)
         
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
            //don't send OSC yet -- just send it to the corrdinate conversion functions
            scaleToOwnZone(i)
         }
         }
      }
   }
   
   override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
   
   
   func sendOSC(id: Int, distance: Float, angle: Float) {
      let newMsg: OSCMessage = OSCMessage(address: "/speaker\(id)")
      newMsg.addFloat(distance)
      newMsg.addFloat(angle)
      newOutPort.sendThisMessage(newMsg)

   }
   
   func scaleToOwnZone(id: Int) {
      //scale differently depending on your id
      _ = CGRectGetMidX(interArray[id].frame)
      _ = CGRectGetMidY(interArray[id].frame)
      var newPosX = ballArray[id].position.x
      var newPosY = ballArray[id].position.y
   //   println(ballArray[id].position)
      // first calculate as x and y but scale to your own zone
      if (id == 0 || id == 1) {
      newPosY = newPosY - size.height/2
      }
      if (id == 1 || id == 2) {
         newPosX = newPosX - size.width/2
      }
     //next convert as if the centre of your zone was the centre of the coordinate system
      newPosX = newPosX - (size.width/4)
      newPosY = newPosY - (size.height/4)

      //then convert to call for a polar conversion
      var d = sqrtf(Float(newPosX) * Float(newPosX) + Float(newPosY) * Float(newPosY))
      d = d/Float(size.width/4)
      var theta = atan2f(Float(newPosY),Float(newPosX));
      if (theta < 0.0)
      {
         theta = theta + Float(M_PI * 2)
      }
      //send these out over OSC
      sendOSC(id, distance: d, angle: theta)
     
   }
   
}
