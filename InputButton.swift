//
//  InputJoystick.swift
//  coolGame
//
//  Created by Nick Seel on 3/13/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class InputButton {
    var x: Double, y: Double
    var size: Double
    
    var pressed: Bool = false
    
    var sprite: SKShapeNode!
    
    init(x: Double, y: Double, size: Double) {
        self.x = x
        self.y = y
        self.size = size
        
        let alpha = CGFloat(0.3)
        
        sprite = SKShapeNode.init(circleOfRadius: CGFloat(size))
        sprite.strokeColor = UIColor.clear
        sprite.fillColor = InputController.buttonColor
        sprite.alpha = alpha
        sprite.zPosition = 500
        sprite.position = CGPoint.init(x: x, y: y)
    }
    
    func update() {
        pressed = false
        for t in InputController.currentTouches {
            if(hypot(x - Double(t.x), y - Double(t.y)) < size) {
                pressed = true
            }
        }
        
        if(pressed) {
            sprite.alpha = 0.7
        } else {
            sprite.alpha = 0.3
        }
    }
}
