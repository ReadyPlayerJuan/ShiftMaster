//
//  PlayerGhost.swift
//  coolGame
//
//  Created by Nick Seel on 3/18/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerGhost: Entity {
    var direction = 0
    var startDirection = 0
    var startX = 0.0
    var startY = 0.0
    
    var blocksMoved = 0.0
    var verticalMovementTimer = 0.0
    var horizontalMovementTimer = 0.0
    var rotation = 0.0
    
    let colAcc = 0.0001
    
    var movingRight = false
    var movingLeft = false
    var waiting = false
    var hingingLeft = false
    var hingingRight = false
    
    var waitNumber = 0.0
    var waitType = 0
    
    var fadingIn = false
    var fadingOut = false
    var fadeStartTime = 0.0
    let fadeTime = 0.8
    
    var currentAction = 0
    var actions = [ghostActions]()
    var active = false
    var lastRun = false
    var appearMode = 0
    
    let maxAlpha = 0.5
    
    enum ghostActions {
        case moveRight(Double)
        case moveLeft(Double)
        case stopMovement
        case hingeRight
        case hingeLeft
        //case fall
        case fadeIn
        case fadeOut
        case wait(Double)
    }
    
    init(startX: Double, startY: Double, appearMode: Int, actions: [ghostActions]) {
        super.init()
        
        zPos = 95
        name = "player ghost"
        isDynamic = true
        autoRotate = false
        
        self.startX = startX
        self.startY = startY
        self.actions = actions
        self.appearMode = appearMode
        
        loadSprite()
        reset()
    }
    
    override func duplicate() -> Entity {
        return PlayerGhost.init(startX: startX, startY: startY, appearMode: appearMode, actions: actions)
    }
    
    func reset() {
        x = startX
        y = startY
        nextX = x
        nextY = y
        xVel = 0.0
        yVel = 0.0
        
        direction = startDirection
        
        verticalMovementTimer = 0
        horizontalMovementTimer = 0
        
        fadingOut = false
        fadingIn = false
        fadeStartTime = 0
        
        currentAction = -1
        nextAction()
    }
    
    override func update(delta: TimeInterval) {
        if(active) {
            xVel = 0
            yVel = 0
            
            if(movingLeft || movingRight) {
                if(movingLeft) {
                    horizontalMovementTimer -= delta * GameState.accelerationBonus
                    if(horizontalMovementTimer < -GameState.slideLength) {
                        horizontalMovementTimer = -GameState.slideLength
                    }
                } else if(movingRight) {
                    horizontalMovementTimer += delta * GameState.accelerationBonus
                    if(horizontalMovementTimer > GameState.slideLength) {
                        horizontalMovementTimer = GameState.slideLength
                    }
                }
                var vel = GameState.maxMoveSpeed * ((horizontalMovementTimer) / GameState.slideLength) * delta
                if(blocksMoved + abs(vel) > waitNumber) {
                    if(vel > 0) {
                        vel = -1 * (waitNumber - (blocksMoved + abs(vel)))
                    } else {
                        vel = waitNumber - (blocksMoved + abs(vel))
                    }
                }
                
                xVel = vel * cos(Double(direction) * (3.14159 / -2))
                yVel = vel * sin(Double(direction) * (3.14159 / -2))
                blocksMoved += abs(vel)
                
                if(blocksMoved > waitNumber) {
                    movingLeft = false
                    movingRight = false
                    blocksMoved = 0
                    waitNumber = 0
                    
                    x = Double(Int(x + 0.5))
                    y = Double(Int(y + 0.5))
                    nextX = x
                    nextY = y
                    
                    nextAction()
                }
            } else if(hingingLeft || hingingRight) {
                let rotationTimeMax = 0.4
                
                x = Double(Int(x + 0.5))
                y = Double(Int(y + 0.5))
                nextX = x
                nextY = y
                
                horizontalMovementTimer += delta
                if(horizontalMovementTimer > rotationTimeMax) {
                    horizontalMovementTimer = rotationTimeMax
                }
                
                let rotationVel = (horizontalMovementTimer / rotationTimeMax) * delta * 120
                
                if(hingingLeft) {
                    rotation += rotationVel
                    if(rotation >= 30) {
                        rotation = 0.0
                        horizontalMovementTimer = 0
                        hingingLeft = false
                        
                        x += cos(Double(direction+1) * (3.14159 / 2))
                        y -= sin(Double(direction+1) * (3.14159 / 2))
                        x = Double(Int(x + 0.5))
                        y = Double(Int(y + 0.5))
                        nextX = x
                        nextY = y
                        
                        direction -= 1
                        direction = (direction+4)%4
                        
                        nextAction()
                    }
                } else {
                    rotation -= rotationVel
                    if(rotation <= -30) {
                        rotation = 0.0
                        horizontalMovementTimer = 0
                        hingingRight = false
                        
                        x += cos(Double(direction) * (3.14159 / 2))
                        y -= sin(Double(direction) * (3.14159 / 2))
                        x = Double(Int(x + 0.5))
                        y = Double(Int(y + 0.5))
                        nextX = x
                        nextY = y
                        
                        direction += 1
                        direction %= 4
                        
                        nextAction()
                    }
                }
            } else {
                if(horizontalMovementTimer < 0) {
                    horizontalMovementTimer += delta
                    if(horizontalMovementTimer > 0) {
                        horizontalMovementTimer = 0
                    }
                } else if(horizontalMovementTimer > 0) {
                    horizontalMovementTimer -= delta
                    if(horizontalMovementTimer < 0) {
                        horizontalMovementTimer = 0
                    }
                }
            }
            
            if(waiting) {
                if(GameState.time > waitNumber) {
                    waiting = false
                    waitNumber = 0
                    
                    nextAction()
                }
            }
            
            if(fadingIn) {
                let prog = min(1, (GameState.time - fadeStartTime) / fadeTime)
                sprite.alpha = CGFloat(prog * maxAlpha)
                
                if(prog == 1) {
                    fadingIn = false
                }
            } else if(fadingOut) {
                let prog = min(1, (GameState.time - fadeStartTime) / fadeTime)
                sprite.alpha = CGFloat((1 - prog) * maxAlpha)
                
                if(prog == 1 && !lastRun) {
                    fadingOut = false
                }
            }
            
            super.update(delta: delta)
            
            
            switch appearMode {
            case 1:
                if(GameState.state == "rotating") {
                    lastRun = true
                    if(!fadingOut && !fadingIn) {
                        fadeStartTime = GameState.time
                        fadingOut = true
                    }
                }
                break
            default:
                break
            }
        } else {
            sprite.alpha = 0.0
            
            switch appearMode {
            case 1:
                if(GameState.prevState == "gaining ability" && GameState.lastFrame) {
                    active = true
                    reset()
                }
                break
            default:
                active = true
                break
            }
        }
    }
    
    private func nextAction() {
        currentAction += 1
        if(currentAction == actions.count) {
            if(lastRun) {
                active = false
            }
            
            reset()
            
        } else {
            
            switch actions[currentAction] {
            case .fadeIn:
                if(!lastRun) {
                    fadeStartTime = GameState.time
                    fadingIn = true
                }
                nextAction()
                break
            case .fadeOut:
                if(!lastRun) {
                    fadeStartTime = GameState.time
                    fadingOut = true
                }
                nextAction()
                break
            case .stopMovement:
                horizontalMovementTimer = 0
                movingLeft = false
                movingRight = false
                hingingLeft = false
                hingingRight = false
                nextAction()
                break
            case .moveRight(let blocks):
                movingRight = true
                waitType = 1
                waitNumber = blocks
                break
            case .moveLeft(let blocks):
                movingLeft = true
                waitType = 1
                waitNumber = blocks
                break
            case .hingeRight:
                hingingRight = true
                horizontalMovementTimer = 0
                rotation = 0.0
                break
            case .hingeLeft:
                hingingLeft = true
                horizontalMovementTimer = 0
                rotation = 0.0
                break
            case .wait(let time):
                waiting = true
                waitType = 0
                waitNumber = GameState.time + time
            }
        }
    }
    
    override func rotate(direction: String) {
        if(direction == "right") {
            self.direction -= 1
            self.direction = (self.direction+4)%4
            
            startDirection -= 1
            startDirection = (startDirection+4)%4
        } else {
            self.direction += 1
            self.direction %= 4
            
            startDirection += 1
            startDirection %= 4
        }
        
        let start = Board.rotatePoint(CGPoint.init(x: startX - 0.5, y: startY + 0.5), clockwise: direction == "right")
        startX = Double(start.x + 0.5)
        startY = Double(start.y - 0.5)
        
        let point = Board.rotatePoint(CGPoint.init(x: x - 0.5, y: y + 0.5), clockwise: direction == "right")
        x = Double(point.x + 0.5)
        y = Double(point.y - 0.5)
        nextX = x
        nextY = y
    }
    
    override func loadSprite() {
        if(sprite.parent != nil) {
            sprite.removeFromParent()
        }
        
        let temp = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: 0, y: 0), rotation: 0.0, size: Double(Board.blockSize)))
        temp.fillColor = UIColor.white
        temp.strokeColor = UIColor.clear
        temp.position = CGPoint(x: x * Double(Board.blockSize), y: -y * Double(Board.blockSize))
        temp.zPosition = zPos
        temp.alpha = 0.0
        
        sprite = temp
    }
    
    override func updateSprite() {
        if(!hingingLeft && !hingingRight) {
            sprite.position = CGPoint.init(x: x * Board.blockSize, y: -y * Board.blockSize)
            sprite.zRotation = CGFloat(Double(direction) * (3.14159 / 2))
        } else if(hingingLeft) {
            sprite.position = CGPoint.init(x: x * Board.blockSize, y: -y * Board.blockSize)
            sprite.zRotation = CGFloat((Double(direction) * (3.14159 / 2)) + (rotation * (3.14159 / 180.0)))
        } else if(hingingRight) {
            sprite.position = CGPoint.init(x: (x + cos(Double(direction) * (3.14159 / 2))) * Board.blockSize, y: -(y - sin(Double(direction) * (3.14159 / 2))) * Board.blockSize)
            sprite.zRotation = CGFloat((Double(direction) * (3.14159 / 2)) + ((rotation + 120.0) * (3.14159 / 180.0)))
        }
    }
}
