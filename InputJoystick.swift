//
//  InputJoystick.swift
//  coolGame
//
//  Created by Nick Seel on 3/13/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class InputJoystick {
    var x: Double, y: Double
    var size: Double
    
    var centerSize: Double
    var maxCenterDistance: Double
    var currentAngle: Double = -1
    
    var prevJoystickTouch: CGPoint? = nil
    
    var sprite: SKShapeNode!
    var innerCircle: SKShapeNode!
    
    init(x: Double, y: Double, size: Double) {
        self.x = x
        self.y = y
        self.size = size
        centerSize = size * (2.0 / 3)
        maxCenterDistance = size * (2.0 / 3)
        
        
        var alpha = CGFloat(0.3)
        
        sprite = SKShapeNode.init(circleOfRadius: CGFloat(size))
        sprite.strokeColor = UIColor.clear
        sprite.fillColor = InputController.buttonColor
        sprite.alpha = alpha
        sprite.zPosition = 0
        sprite.position = CGPoint.init(x: x, y: y)
        
        
        alpha = 0.92
        
        innerCircle = SKShapeNode.init(circleOfRadius: CGFloat(centerSize))
        innerCircle.strokeColor = UIColor.clear
        innerCircle.fillColor = InputController.buttonColor
        innerCircle.alpha = alpha
        innerCircle.zPosition = 1
        
        sprite.addChild(innerCircle)
    }
    
    func update() {
        if(prevJoystickTouch == nil) {
            var finished = false
            
            for t in InputController.currentTouches {
                if(!finished) {
                    if(hypot(x - Double(t.x), y - Double(t.y)) < size * 1.5) {
                        finished = true
                        prevJoystickTouch = t
                        
                        currentAngle = atan((y - Double(t.y)) / (x - Double(t.x) + 0.0000001))
                        if(currentAngle < 0) {
                            currentAngle += 3.14159
                        }
                        if(Double(t.y) < y) {
                            currentAngle += 3.14159
                        }
                    }
                }
            }
        } else {
            var finished = false
            
            if(InputController.prevTouches.count > 0) {
                for i in 0...InputController.prevTouches.count-1 {
                    if(i < InputController.currentTouches.count) {
                        if(InputController.currentTouches[i].equalTo(prevJoystickTouch!)) {
                            finished = true
                            prevJoystickTouch = InputController.currentTouches[i]
                            
                            let t = InputController.currentTouches[i]
                            
                            currentAngle = atan((y - Double(t.y)) / (x - Double(t.x) + 0.0000001))
                            if(currentAngle < 0) {
                                currentAngle += 3.14159
                            }
                            if(Double(t.y) < y) {
                                currentAngle += 3.14159
                            }
                        }
                    }
                }
            }
            
            if(!finished) {
                prevJoystickTouch = nil
            }
        }
        
        if(prevJoystickTouch == nil) {
            currentAngle = -1
            
            innerCircle.position = CGPoint(x: 0, y: 0)
        } else {
            if(hypot(Double(prevJoystickTouch!.x)-x, Double(prevJoystickTouch!.y)-y) < maxCenterDistance) {
                innerCircle.position = CGPoint(x: Double(prevJoystickTouch!.x)-x, y: Double(prevJoystickTouch!.y)-y)
            } else {
                innerCircle.position = CGPoint(x: maxCenterDistance*cos(currentAngle), y: maxCenterDistance*sin(currentAngle))
            }
        }
    }
}
