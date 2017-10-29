//
//  Entity.swift
//  another test game
//
//  Created by Nick Seel on 12/10/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class Entity {
    var x = 0.0, y = 0.0, xVel = 0.0, yVel = 0.0
    var isDynamic = true
    var collisionType = 0
    var collidesWithType = [0]
    var collisionPriority = 0
    var isDangerous = false
    var autoRotate = true
    
    var isInactive = false
    var invertExclusive: Bool = false
    var invertVisible: Bool = false
    
    var name = ""
    var hitboxType = HitboxType.none
    
    enum HitboxType {
        case none
        case block
        case movingBlock
        case player
    }
    
    var controllable = false
    var nextX = 0.0, nextY = 0.0
    
    var zPos: CGFloat = 0.0
    
    var ID: Int = 0
    
    var nearbyEntities: [Entity] = []
    
    var defaultSpriteColor: UIColor = UIColor.purple
    var sprite: SKNode!
    var shader: SKShader!
    
    init() {
        ID = EntityManager.getID()
    }
    
    func update(delta: TimeInterval) {
        nextX = x + xVel
        nextY = y + yVel
        
        if(invertExclusive && ((GameState.inverted && !invertVisible) || (!GameState.inverted && invertVisible))) {
            sprite.alpha = 0.0
            isInactive = true
        } else {
            sprite.alpha = 1.0
            isInactive = false
        }
    }
    func checkForCollision() {}
    func move() {
        x = nextX
        y = nextY
    }
    
    func updateAttributes() {}
    func load() {}
    
    func gameActionFirstFrame(_ action: GameAction) {
        switch(action) {
        case .rotateLeft:
            let newX = y
            let newY = Double(Board.boardHeight) - x - 1
            nextX = newX
            nextY = newY
            x = nextX
            y = nextY
            sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
            break
        case .rotateRight:
            let newX = Double(Board.boardWidth) - y - 1
            let newY = x
            nextX = newX
            nextY = newY
            x = nextX
            y = nextY
            sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
            break
        case .rotateLeftInstant:
            let newX = y
            let newY = Double(Board.boardHeight) - x - 1
            nextX = newX
            nextY = newY
            x = nextX
            y = nextY
            sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
            break
        case .rotateRightInstant:
            let newX = Double(Board.boardWidth) - y - 1
            let newY = x
            nextX = newX
            nextY = newY
            x = nextX
            y = nextY
            sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
            break
        default:
            break
        }
    }
    func gameActionLastFrame(_ action: GameAction) {}
    
    static func collides(this: Entity, with: Entity) -> Bool {
        return arrayContains(array: this.collidesWithType, number: with.collisionType)
    }
    
    private static func arrayContains(array: [Int], number: Int) -> Bool {
        for i in array {
            if(i == number) {
                return true
            }
        }
        return false
    }
    
    func removeSpriteFromParent() {
        if(sprite.parent != nil) {
            sprite.removeFromParent()
        }
    }
    
    func rectContainsPoint(rect: CGRect, point: CGPoint) -> Bool {
        return (point.x >= rect.minX && point.x <= rect.maxX && point.y >= rect.minY && point.y <= rect.maxY)
    }
    
    func duplicate() -> Entity {
        return Entity.init()
    }
    
    func equals(_ otherEntity: Entity) -> Bool {
        return name == otherEntity.name && x == otherEntity.x && y == otherEntity.y && ID == otherEntity.ID
    }
    
    func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
