//
//  EditorButton.swift
//  coolGame
//
//  Created by Nick Seel on 6/23/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class EditorButton {
    var pressTimer: Double = 0.0
    var pressTimerMax = 0.1
    
    var isPressed = false
    var prevPressed = false
    var action = false
    
    var hitbox: CGRect!
    var sprite: SKNode!
    
    init(x: Double, y: Double) {
    }
    
    func setHitboxPosition(x: Double, y: Double, width: Double, height: Double) {
        hitbox = CGRect(x: x - (width / 2), y: y - (height / 2), width: width, height: height)
    }
    
    func update(active: Bool, delta: TimeInterval) {
        prevPressed = isPressed
        isPressed = false
        action = false
        
        for t in InputController.prevTouches {
            if(hitbox.contains(t) && active && InputController.prevTouches.count == 1) {
                isPressed = true
            }
        }
        if(isPressed && !prevPressed && pressTimer == 0) {
            pressTimer = pressTimerMax
            action = true
        } else {
            if(pressTimer > 0) {
                pressTimer -= delta
                
                if(pressTimer <= 0) {
                    pressTimer = 0.0
                }
            }
        }
    }
}
