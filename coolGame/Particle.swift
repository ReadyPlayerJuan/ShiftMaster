//
//  Particle.swift
//  coolGame
//
//  Created by Nick Seel on 2/24/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class Particle {
    var x: Double, y: Double, rotation: Double, startX: Double, startY: Double, startRotation: Double, endX: Double, endY: Double, endRotation: Double
    var shape: Int
    var color: UIColor
    var lifeTime: Double
    var deathTimer: Double
    var deathType: Int
    
    let zPos = 101
    
    var sprite: SKShapeNode!
    
    init(x: Double, y: Double, endX: Double, endY: Double, shape: Int, color: UIColor, lifeTime: Double, deathType: Int) {
        self.x = x
        self.y = y
        startX = x
        startY = y
        self.endX = endX
        self.endY = endY
        self.shape = shape
        self.color = color
        self.lifeTime = lifeTime
        deathTimer = lifeTime
        self.deathType = deathType
        rotation = 0
        startRotation = 0
        endRotation = 0
        
        loadSprite()
    }
    
    init(x: Double, y: Double, angle: Double, distance: Double, shape: Int, color: UIColor, lifeTime: Double, deathType: Int) {
        self.x = x
        self.y = y
        startX = x
        startY = y
        endX = x + distance*cos(angle * (3.14159 / 180.0))
        endY = y + distance*sin(angle * (3.14159 / 180.0))
        self.shape = shape
        self.color = color
        self.lifeTime = lifeTime
        deathTimer = lifeTime
        self.deathType = deathType
        rotation = 0
        startRotation = 0
        endRotation = 0
        
        loadSprite()
    }
    
    init(x: Double, y: Double, angle: Double, distance: Double, startAngle: Double, endAngle: Double, shape: Int, color: UIColor, lifeTime: Double, deathType: Int) {
        self.x = x
        self.y = y
        startX = x
        startY = y
        endX = x + distance*cos(angle * (3.14159 / 180.0))
        endY = y + distance*sin(angle * (3.14159 / 180.0))
        self.shape = shape
        self.color = color
        self.lifeTime = lifeTime
        deathTimer = lifeTime
        self.deathType = deathType
        startRotation = startAngle * (3.14159 / 180.0)
        endRotation = endAngle * (3.14159 / 180.0)
        rotation = startRotation
        
        loadSprite()
    }
    
    func loadSprite() {
        let size = 0.2
        
        switch(shape) {
        case 0: //square
            sprite = SKShapeNode.init(rect: CGRect.init(x: -(size/2)*Board.blockSize, y: -(size/2)*Board.blockSize, width: size*Board.blockSize, height: size*Board.blockSize))
            break
        case 1: //triangle
            let height = size*(sqrt(3.0)/2.0)
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: -(size/2)*Board.blockSize, y: -(height/3)*Board.blockSize))
            path.addLine(to: CGPoint(x: (size/2)*Board.blockSize, y: -(height/3)*Board.blockSize))
            path.addLine(to: CGPoint(x: 0, y: (height/1.5)*Board.blockSize))
            sprite = SKShapeNode.init(path: path.cgPath)
            break
        default:
            break
        }
        
        sprite.zPosition = 110
        sprite.fillColor = color
        sprite.strokeColor = UIColor.clear
        sprite.position = CGPoint.init(x: x*Board.blockSize, y: -y*Board.blockSize)
    }
    
    func isAlive() -> Bool {
        return deathTimer > 0
    }
    
    func update(delta: TimeInterval) {
        deathTimer -= delta
        if(deathTimer < 0) {
            deathTimer = 0
        }
        
        switch(deathType) {
        case 0:
            let prog = pow(max(0.0, min(1.0, (1.1 * (deathTimer / lifeTime)) - 0.1)), 2)
            x = (prog * startX) + ((1-prog) * endX)
            y = (prog * startY) + ((1-prog) * endY)
            rotation = (prog * startRotation) + ((1-prog) * endRotation)
            sprite.alpha = CGFloat(min(1, prog*2))
            break
        case 1:
            let prog =  pow( max(0.0, min(1.0, (1.1 * (deathTimer / lifeTime)) - 0.1)), 1.5)
            x = (prog * startX) + ((1-prog) * endX)
            y = (prog * startY) + ((1-prog) * endY)
            rotation = (prog * startRotation) + ((1-prog) * endRotation)
            sprite.alpha = CGFloat(prog)
            break
        default:
            break
        }
        
        sprite.zRotation = CGFloat(rotation)
        sprite.position = CGPoint.init(x: x*Board.blockSize, y: -y*Board.blockSize)
    }
}
