//
//  MovingBlock.swift
//  another test game
//
//  Created by Nick Seel on 12/10/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit
/*
class MovingBlock: Entity {
    var startX = 0.0
    var startY = 0.0
    
    var direction = 0
    var colorIndex = -1
    var color = UIColor.purple
    var falling = false
    
    var movementTimer = 0.0
    
    init(color: Int, dir: Int, xPos: Double, yPos: Double) {
        super.init()
        
        direction = dir
        direction %= 2
        x = xPos
        y = yPos
        startX = xPos
        startY = yPos
        
        name = "moving block"
        isDynamic = true
        collisionPriority = 10
        zPos = 10
        colorIndex = color
        
        if(colorIndex == -1) {
            collidesWithType = [0, 10, 11, 12, 13, 14, 15]
            collisionType = 0
            falling = true
        } else {
            collidesWithType = [0, 10, 11, 12, 13, 14, 15]
            collisionType = colorIndex + 10
        }
        
        initColor()
        
        loadSprite()
    }
    
    override func rotate(direction: String) {
        if(colorIndex == -1 || (EntityManager.getPlayer() as! Player).colorIndex == colorIndex) {
            falling = true
        } else {
            falling = false
        }
    }
    
    override func duplicate() -> Entity {
        return MovingBlock.init(color: colorIndex, dir: direction, xPos: x, yPos: y)
    }
    
    override func update(delta: TimeInterval) {
        if(GameState.prevPlayerState == "changing color" && GameState.lastFrame) {
            if((EntityManager.getPlayer() as! Player).colorIndex == colorIndex) {
                falling = true
            } else {
                falling = false
            }
        }
        
        let prevMovementTimer = movementTimer
        if(GameState.playerState == "free" || GameState.playerState == "rotating" || GameState.playerState == "changing color" || GameState.playerState == "respawning") {
            if((Board.direction + direction) % 2 == 0 && falling) {
                movementTimer += delta
                
                let prevHeight = heightAt(time: prevMovementTimer)
                let nextHeight = heightAt(time: movementTimer)
                yVel = nextHeight - prevHeight
            } else if(xVel > 0) {
                let prevHeight = heightAt(time: movementTimer)
                let nextHeight = heightAt(time: movementTimer+delta)
                xVel = nextHeight - prevHeight
            } else if(xVel < 0) {
                let prevHeight = heightAt(time: movementTimer)
                let nextHeight = heightAt(time: movementTimer+delta)
                xVel = nextHeight - prevHeight
                xVel *= -1
            } else {
                movementTimer = 0
            }
            
            if(GameState.state == "resetting stage") {
                updateSprite()
            }
        } else if(GameState.state == "rotating") {
            if(xVel > 0) {
                let prevHeight = heightAt(time: movementTimer)
                let nextHeight = heightAt(time: movementTimer+delta)
                xVel = nextHeight - prevHeight
            } else if(xVel < 0) {
                let prevHeight = heightAt(time: movementTimer)
                let nextHeight = heightAt(time: movementTimer+delta)
                xVel = nextHeight - prevHeight
                xVel *= -1
            }
        } else {
            movementTimer = 0
        }
        
        sprite.position = CGPoint(x: x * Double(Board.blockSize), y: -y * Double(Board.blockSize))
        
        super.update(delta: delta)
    }
    
    override func updateSprite() {
        if(GameState.state == "resetting stage" && sprite.name != nil && sprite.name! == "resetting") {
            if(sprite.children.count  == 2) {
                let prog = GameState.deathTimer / GameState.deathTimerMax
                sprite.children[0].alpha = CGFloat(prog)
                sprite.children[1].alpha = CGFloat(1 - prog)
            }
        }
    }
    
    private func heightAt(time: Double) -> Double {
        return (GameState.gravity * (time * time)) + GameState.jumpHeight
    }
    
    func initColor() {
        //var color = UIColor.purple
        if(colorIndex == -1) {
            let blockVariation = Int(rand()*Board.colorVariation)
            color = UIColor(red: 1.0-(CGFloat(blockVariation)/255.0), green: 1.0-(CGFloat(blockVariation)/255.0), blue: 1.0-(CGFloat(blockVariation)/255.0), alpha: 1.0)
        } else {
            let n = 1.0
            let blockVariation = Int((Board.colorVariation*n) - (rand()*Board.colorVariation*2*n))
            var colorArray = ColorTheme.colors[Board.colorTheme][colorIndex]
            
            for index in 0 ... 2 {
                colorArray[index] = max(min(colorArray[index] + blockVariation, 255), 0)
            }
            
            color = UIColor(red: CGFloat(colorArray[0]) / 255.0, green: CGFloat(colorArray[1]) / 255.0, blue: CGFloat(colorArray[2]) / 255.0, alpha: 1.0)
        }
    }
    
    override func checkForCollision() {
        let colAcc = 0.001
        
        for entity in nearbyEntities {
            if(entity.name == "block") {
                if(Entity.collides(this: self, with: entity)) {
                    if(yVel > 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: x + colAcc, y: nextY)) || rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: x + 1 - colAcc, y: nextY)) )  {
                            
                            nextY = entity.nextY - 1
                            yVel = 0
                            movementTimer = 0
                            
                            falling = false
                        }
                    } else if(xVel < 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY, width: 1.0, height: 1.0), point: CGPoint(x: nextX, y: y + colAcc)) || rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY, width: 1.0, height: 1.0), point: CGPoint(x: nextX, y: y + 1 - colAcc)) )  {
                            
                            nextX = entity.nextX + 1
                            xVel = 0
                            movementTimer = 0
                            
                            falling = false
                        }
                    } else if(xVel > 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY, width: 1.0, height: 1.0), point: CGPoint(x: nextX + 1, y: y + colAcc)) || rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY, width: 1.0, height: 1.0), point: CGPoint(x: nextX + 1, y: y + 1 - colAcc)) )  {
                            
                            nextX = entity.nextX - 1
                            xVel = 0
                            movementTimer = 0
                            
                            falling = false
                        }
                    }
                }
            } else if(entity.name == "moving block") {
                if(Entity.collides(this: self, with: entity) || Entity.collides(this: entity, with: self)) {
                    if(yVel > 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: x + colAcc, y: nextY)) || rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: x + 1 - colAcc, y: nextY)) )  {
                            
                            nextY = entity.nextY - 1
                            yVel = 0
                            movementTimer = 0
                            
                            if(!(entity as! MovingBlock).falling) {
                                falling = false
                            }
                        }
                    } else if(xVel > 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY, width: 1.0, height: 1.0), point: CGPoint(x: nextX, y: y + colAcc)) || rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY, width: 1.0, height: 1.0), point: CGPoint(x: nextX, y: y + 1 - colAcc)) )  {
                            
                            nextX = entity.nextX + 1
                            xVel = 0
                            movementTimer = 0
                            
                            if(!(entity as! MovingBlock).falling) {
                                falling = false
                            }
                        }
                    } else if(xVel < 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY, width: 1.0, height: 1.0), point: CGPoint(x: nextX + 1, y: y + colAcc)) || rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY, width: 1.0, height: 1.0), point: CGPoint(x: nextX + 1, y: y + 1 - colAcc)) )  {
                            
                            nextX = entity.nextX - 1
                            xVel = 0
                            movementTimer = 0
                            
                            if(!(entity as! MovingBlock).falling) {
                                falling = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func beginStageReset() {
        sprite = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: 1, height: 1))
        sprite.fillColor = UIColor.clear
        sprite.strokeColor = UIColor.clear
        
        
        let s = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Double(Board.blockSize+0), height: Double(Board.blockSize+0)))
        s.position = CGPoint(x: x*Double(Board.blockSize), y: -y*Double(Board.blockSize))
        s.fillColor = color
        s.strokeColor = UIColor.clear
        s.zPosition = zPos
        
        let s2 = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Double(Board.blockSize+0), height: Double(Board.blockSize+0)))
        s2.position = CGPoint(x: startX*Double(Board.blockSize), y: -startY*Double(Board.blockSize))
        s2.fillColor = color
        s2.strokeColor = UIColor.clear
        s2.zPosition = zPos
        
        if((direction + Board.direction) % 2 == 0) {
            let arrow1 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: Double(Board.blockSize)*(1/3.0), y: Double(Board.blockSize)*((1/2.0) + (1/18.0))), rotation: 0.0, size: Double(Board.blockSize)*(1/3.0)))
            arrow1.strokeColor = UIColor.black
            arrow1.fillColor = UIColor.clear
            arrow1.lineWidth = CGFloat(Double(Board.blockSize) / 25.0)
            arrow1.zPosition = 1
            let arrow2 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: Double(Board.blockSize)*(2/3.0), y: Double(Board.blockSize)*((1/2.0) - (1/18.0))), rotation: 180.0, size: Double(Board.blockSize)*(1/3.0)))
            arrow2.strokeColor = UIColor.black
            arrow2.fillColor = UIColor.clear
            arrow2.lineWidth = CGFloat(Double(Board.blockSize) / 25.0)
            arrow2.zPosition = 1
            s.addChild(arrow1)
            s.addChild(arrow2)
            s2.addChild(arrow1.copy() as! SKShapeNode)
            s2.addChild(arrow2.copy() as! SKShapeNode)
        } else {
            let arrow1 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: Double(Board.blockSize)*((1/2.0) - (1/18.0)), y: Double(Board.blockSize)*(1/3.0)), rotation: 90.0, size: Double(Board.blockSize)*(1/3.0)))
            arrow1.strokeColor = UIColor.black
            arrow1.fillColor = UIColor.clear
            arrow1.lineWidth = CGFloat(Double(Board.blockSize) / 25.0)
            arrow1.zPosition = 1
            let arrow2 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: Double(Board.blockSize)*((1/2.0) + (1/18.0)), y: Double(Board.blockSize)*(2/3.0)), rotation: -90.0, size: Double(Board.blockSize)*(1/3.0)))
            arrow2.strokeColor = UIColor.black
            arrow2.fillColor = UIColor.clear
            arrow2.lineWidth = CGFloat(Double(Board.blockSize) / 25.0)
            arrow2.zPosition = 1
            s.addChild(arrow1)
            s.addChild(arrow2)
            s2.addChild(arrow1.copy() as! SKShapeNode)
            s2.addChild(arrow2.copy() as! SKShapeNode)
        }
        
        sprite.addChild(s)
        sprite.addChild(s2)
        sprite.name = "resetting"
    }
    
    override func loadSprite() {
            let s = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Double(Board.blockSize+0), height: Double(Board.blockSize+0)))
            s.position = CGPoint(x: x*Double(Board.blockSize), y: -y*Double(Board.blockSize))
            s.fillColor = color
            s.strokeColor = UIColor.clear
            s.zPosition = zPos
            self.sprite = s
            
            if((direction + Board.direction) % 2 == 0) {
                let arrow1 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: Double(Board.blockSize)*(1/3.0), y: Double(Board.blockSize)*((1/2.0) + (1/18.0))), rotation: 0.0, size: Double(Board.blockSize)*(1/3.0)))
                arrow1.strokeColor = UIColor.black
                arrow1.fillColor = UIColor.clear
                arrow1.lineWidth = CGFloat(Double(Board.blockSize) / 25.0)
                arrow1.zPosition = 1
                let arrow2 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: Double(Board.blockSize)*(2/3.0), y: Double(Board.blockSize)*((1/2.0) - (1/18.0))), rotation: 180.0, size: Double(Board.blockSize)*(1/3.0)))
                arrow2.strokeColor = UIColor.black
                arrow2.fillColor = UIColor.clear
                arrow2.lineWidth = CGFloat(Double(Board.blockSize) / 25.0)
                arrow2.zPosition = 1
                sprite.addChild(arrow1)
                sprite.addChild(arrow2)
            } else {
                let arrow1 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: Double(Board.blockSize)*((1/2.0) - (1/18.0)), y: Double(Board.blockSize)*(1/3.0)), rotation: 90.0, size: Double(Board.blockSize)*(1/3.0)))
                arrow1.strokeColor = UIColor.black
                arrow1.fillColor = UIColor.clear
                arrow1.lineWidth = CGFloat(Double(Board.blockSize) / 25.0)
                arrow1.zPosition = 1
                let arrow2 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: Double(Board.blockSize)*((1/2.0) + (1/18.0)), y: Double(Board.blockSize)*(2/3.0)), rotation: -90.0, size: Double(Board.blockSize)*(1/3.0)))
                arrow2.strokeColor = UIColor.black
                arrow2.fillColor = UIColor.clear
                arrow2.lineWidth = CGFloat(Double(Board.blockSize) / 25.0)
                arrow2.zPosition = 1
                sprite.addChild(arrow1)
                sprite.addChild(arrow2)
            }
    }
}*/
