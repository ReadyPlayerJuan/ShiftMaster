//
//  Camera.swift
//  coolGame
//
//  Created by Nick Seel on 3/14/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class Camera {
    static var drawNode: SKNode!
    
    static var shakeTimer = 0.0
    static var shakeTimerMax = 0.1
    static var shakeXPeriod = 0.0
    static var shakeYPeriod = 0.0
    static var shakeIntensity = 1.0
    static var shakeDropoff = true
    static let maxShakeDistance = 0.07
    
    static var cameraLockonSpeed = 9999.0
    static var cameraZoomSpeed = 9999.0
    
    static var currentX = -9999.0
    static var currentY = -9999.0
    static var currentZoom = 1.0
    
    static var targetX = -9999.0
    static var targetY = -9999.0
    static var targetZoom = 1.0
    
    static var xMod = 0.0
    static var yMod = 0.0
    
    class func update(delta: Double) {
        if(shakeTimer > 0) {
            shakeTimer -= delta
            
            var shakeDistance = shakeIntensity * maxShakeDistance
            if(shakeDropoff) {
                shakeDistance *= (shakeTimer / shakeTimerMax)
            }
            xMod = Board.blockSize * shakeDistance * cos(shakeTimer * shakeXPeriod)
            yMod = Board.blockSize * shakeDistance * sin(shakeTimer * shakeYPeriod)
            
            if(shakeTimer <= 0) {
                shakeTimer = 0
            }
        } else {
            xMod = 0
            yMod = 0
        }
        
        currentX += (targetX - currentX) * min(1, delta * cameraLockonSpeed)
        currentY += (targetY - currentY) * min(1, delta * cameraLockonSpeed)
        currentZoom += (targetZoom - currentZoom) * min(1, delta * cameraZoomSpeed)
        
        drawNode.position = CGPoint.init(x: (currentX + xMod) * targetZoom, y: (currentY + yMod) * currentZoom)
        drawNode.xScale = CGFloat(currentZoom)
        drawNode.yScale = CGFloat(currentZoom)
    }
    
    class func shake(forTime: Double, withIntensity: Double, dropoff: Bool) {
        shakeTimer = forTime
        shakeTimerMax = forTime
        shakeIntensity = withIntensity
        shakeDropoff = dropoff
        
        let n = 90.0 //average value
        let m = n/4.0 //max variation
        shakeXPeriod = n + ((rand() * m * 2) - m)
        shakeYPeriod = n + ((rand() * m * 2) - m)
    }
 
    class func centerOnPlayer() {
        targetX = -((Double((EntityManager.getPlayer() as! Player).getCenter().x) + 0.0) * Double(Board.blockSize))
        targetY = ((Double((EntityManager.getPlayer() as! Player).getCenter().y) - 0.0) * Double(Board.blockSize))
    }
    
    class func centerOnPoint(_ p: CGPoint) {
        targetX = Double(p.x)
        targetY = Double(p.y)
    }
    
    class func centerOnEditorCamera() {
        //targetX = -Double((EditorManager.camera.x + 0.5) * CGFloat(Board.blockSize))
        //targetY = Double((EditorManager.camera.y - 0.5) * CGFloat(Board.blockSize))
    }
    
    class func centerOnDeathVector() {
        //targetX = -((Double((EntityManager.getPlayer() as! Player).getCenter().x) + Double(GameState.getDeathVector().dx) + 0.0) * Double(Board.blockSize))
        //targetY = ((Double((EntityManager.getPlayer() as! Player).getCenter().y) + Double(GameState.getDeathVector().dy) - 0.0) * Double(Board.blockSize))
    }
    
    class func centerOnStageTransitionVector() {
        //targetX = -(Double((EntityManager.getPlayer() as! Player).getCenter().x) * Double(Board.blockSize)) + Double(GameState.getStageTransitionVector().dx)
        //targetY = (Double((EntityManager.getPlayer() as! Player).getCenter().y) * Double(Board.blockSize)) + Double(GameState.getStageTransitionVector().dy)
    }
    
    private class func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
