//
//  InputController.swift
//  Drawing Test
//
//  Created by Erin Seel on 11/26/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import GameplayKit

class InputController {
    static var prevTouches = [CGPoint]()
    static var currentTouches = [CGPoint]()
    
    static let maxTouchLeniency = CGFloat(50.0)
    
    static var inputButtonNode: SKNode!
    static var joystick: InputJoystick!
    static var button: InputButton!
    
    static let gray = CGFloat(0.8)
    static let buttonColor = UIColor.init(red: gray, green: gray, blue: gray, alpha: 1.0)
    
    static func initElements() {
        let size = 60.0
        joystick = InputJoystick.init(x: -Double(GameState.screenWidth/2) + (3*size/2), y: -Double(GameState.screenHeight/2) + (5*size/4), size: 50.0)
        button = InputButton.init(x: Double(GameState.screenWidth/2) - (3*size/2), y: -Double(GameState.screenHeight/2) + (5*size/4), size: 50.0)
        
        inputButtonNode.addChild(joystick.sprite)
        inputButtonNode.addChild(button.sprite)
    }
    
    static func update() {
        joystick.update()
        button.update()
    }
    
    static func resetTouches() {
        currentTouches = [CGPoint]()
        prevTouches = [CGPoint]()
    }
    
    static func touchesBegan(_ touches: Set<UITouch>, node: SKNode) {
        for t in touches {
            currentTouches.append(t.location(in: node))
        }
    }
    
    static func touchesMoved(_ touches: Set<UITouch>, node: SKNode) {
        for t in touches {
            if(currentTouches.count > 0) {
                for i in 0...currentTouches.count-1 {
                    let ct = currentTouches[i]
                    if(hypot(t.previousLocation(in: node).x-(ct.x), t.previousLocation(in: node).y-(ct.y)) < maxTouchLeniency) {
                        currentTouches[i] = t.location(in: node)
                    }
                }
            }
        }
    }
    
    static func touchesEnded(_ touches: Set<UITouch>, node: SKNode) {
        for t in touches {
            var remove = [Int]()
            if(currentTouches.count > 0) {
                for i in 0...currentTouches.count-1 {
                    let ct = currentTouches[i]
                    if(hypot(t.location(in: node).x-(ct.x), t.location(in: node).y-(ct.y)) < maxTouchLeniency) {
                        remove.insert(i, at: 0)
                    }
                }
                for i in remove {
                    if(i < currentTouches.count) {
                        currentTouches.remove(at: i)
                    }
                }
            }
        }
    }
    
    static func touchesCancelled(_ touches: Set<UITouch>, node: SKNode) {
        for t in touches {
            var remove = [Int]()
            if(currentTouches.count > 0) {
                for i in 0...currentTouches.count-1 {
                    let ct = currentTouches[i]
                    if(hypot(t.location(in: node).x-(ct.x), t.location(in: node).y-(ct.y)) < maxTouchLeniency) {
                        remove.insert(i, at: 0)
                    }
                }
                for i in remove {
                    if(i < currentTouches.count) {
                        currentTouches.remove(at: i)
                    }
                }
            }
        }
    }
}
