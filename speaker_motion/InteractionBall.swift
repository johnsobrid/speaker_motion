//
//  InteractionBall.swift
//  speaker_motion
//
//  Created by Bridget Johnson on 19/06/15.
//  Copyright (c) 2015 bdj. All rights reserved.
//

import UIKit
import SpriteKit

class InteractionBall: SKSpriteNode {
   
   init() {
      let texture = SKTexture(imageNamed:"ball")
      super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }
}
