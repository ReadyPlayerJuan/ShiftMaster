//
//  PlayerMovement.swift
//  coolGame
//
//  Created by Nick Seel on 1/14/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

extension Player {
    func move(delta: Double) {
        //print(movingLeft, movingRight, horizontalMovementTimer)
        //print(verticalMovementTimer)
        if((movingLeft && !movingRight) || (movingLeft && movingRight && horizontalMovementTimer < 0)) {
            horizontalMovementTimer -= delta * GameState.accelerationBonus
            if(horizontalMovementTimer < -GameState.slideLength) {
                horizontalMovementTimer = -GameState.slideLength
            }
        } else if((movingRight && !movingLeft) || (movingLeft && movingRight && horizontalMovementTimer > 0)) {
            horizontalMovementTimer += delta * GameState.accelerationBonus
            if(horizontalMovementTimer > GameState.slideLength) {
                horizontalMovementTimer = GameState.slideLength
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
        xVel = GameState.maxMoveSpeed * ((horizontalMovementTimer) / GameState.slideLength) * delta
        
        if(jumping) {
            if(y == Double(Int(y)) && verticalMovementTimer == 0) {
                //jump
                verticalMovementTimer = -GameState.jumpLength
                //jump particles
                let numParticles = Int(2.5+(rand()*0.9))
                for i in 0...numParticles-1 {
                    var xPos: Double = rand()
                    var angle: Double
                    
                    xPos = (rand() * (1.0 / Double(numParticles))) + (Double(i) / Double(numParticles))
                    angle = ((rand() * 60) - 30) - ((1 - xPos) * 180)
                    
                    /*let block = Board.blocks[Int(y + 1.5)][Int(x+xPos)]!
                    if(block.type != 0 && block.type != 5 && Entity.collides(this: self, with: block)) {
                        EntityManager.addParticle(particle: Particle.init(x: x+xPos, y: y + ((rand() - 0.5) * 0.2), angle: angle, distance: 0.2 + (rand()*0.2), shape: 0, color: block.color, lifeTime: 0.3+(rand()*0.3), deathType: 0))
                    }*/
                }
            }
        }
        let prevHeight = GameState.heightAt(time: verticalMovementTimer)
        verticalMovementTimer += delta
        if(verticalMovementTimer > 0 && verticalMovementTimer-delta < 0 && prevYVel < 0) {
            verticalMovementTimer = 0
        }
        let nextHeight = GameState.heightAt(time: verticalMovementTimer)
        yVel = nextHeight - prevHeight
        
        prevXVel = xVel
        prevYVel = yVel
        
        super.update(delta: delta, actions: [])
    }
    
    func rotate(delta: Double) {
        yVel = 0
        verticalMovementTimer = 0
        nextY = Double(Int(nextY + 0.5))
        
        let rotationTimeMax = 0.4
        
        if(movingLeft || movingRight) {
            if((movingLeft && hingeDirection == "left") || (movingRight && hingeDirection == "right")) {
                horizontalMovementTimer += delta
            } else {
                horizontalMovementTimer -= delta
            }
        } else {
            horizontalMovementTimer -= delta / 2.0
        }
        if(horizontalMovementTimer > rotationTimeMax) {
            horizontalMovementTimer = rotationTimeMax
        }
        
        rotationVel = (horizontalMovementTimer / rotationTimeMax) * delta * 120
        
        if(hingeDirection == "left") {
            rotation += rotationVel
            if(rotation >= 30) {
                rotation = 30.0
                rotationVel = 0.0
                horizontalMovementTimer = 0
                GameState.gameAction(GameAction.rotateLeft)
            } else if(rotation < 0) {
                rotation = 0.0
                rotationVel = 0.0
                horizontalMovementTimer = 0
                hinging = false
                sprite.zRotation = 0
            }
        } else {
            rotation -= rotationVel
            if(rotation <= -30) {
                rotation = -30.0
                rotationVel = 0.0
                horizontalMovementTimer = 0
                GameState.gameAction(GameAction.rotateRight)
            } else if(rotation > 0) {
                rotation = 0.0
                rotationVel = 0.0
                horizontalMovementTimer = 0
                hinging = false
                sprite.zRotation = 0
            }
        }
    }
    
    func checkInputForMovement() {
        movingLeft = false
        movingRight = false
        jumping = false
        
        if(InputController.joystick.currentAngle != -1) {
            if(InputController.joystick.currentAngle > (3.14159 / 2) && InputController.joystick.currentAngle < (3.14159 * (3 / 2))) {
                movingLeft = true
            } else {
                movingRight = true
            }
        }
        
        if(InputController.button.pressed) {
            jumping = true
        }
    }
    
    func collide() {
        canHingeLeft = false
        canHingeRight = false
        hitCeiling = false
        
        checkNorthSouthCollision()
        checkEastWestCollision()
        
        //print(canHingeLeft)
        if(!GameState.stopPlayerMovement) {
            if(x == Double(Int(x)) && y == Double(Int(y)) && xVel == 0 && yVel == 0) {
                if(movingLeft && canHingeLeft) {
                    horizontalMovementTimer = 0
                    hinging = true
                    hingeDirection = "left"
                    rotationVel = 0.1
                    rotation = 0.0
                } else if(movingRight && canHingeRight) {
                    horizontalMovementTimer = 0
                    hinging = true
                    hingeDirection = "right"
                    rotationVel = -0.1
                    rotation = 0.0
                }
            }
        }
    }

    func checkNorthSouthCollision() {
        for entity in nearbyEntities {
            
            //following code cotains collision instruction for blocks and moving blocks only, in the y direction
            if(entity.hitboxType == HitboxType.block || entity.hitboxType == HitboxType.movingBlock) {
                
                //make sure the player is able to collide with the current block or moving block by the collision rules defined by entity class
                if(Entity.collides(this: self, with: entity)) {
                    
                    let colAcc = 0.001
                    
                    if(yVel > 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: x + colAcc, y: nextY)) || rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: x + 1 - colAcc, y: nextY)) )  {
                            
                            if(abs(verticalMovementTimer) > sqrt(2.5 / GameState.gravity)) {
                                /*let numParticles = Int(2.3+(rand()*1.7))
                                for i in 0...numParticles-1 {
                                    var xPos: Double = rand()
                                    var angle: Double
                                    
                                    if(i == 0) {
                                        xPos = rand()*0.4 + 0.1
                                    } else if(i == 1) {
                                        xPos = rand()*0.4 + 0.5
                                    }
                                    
                                    if(i == 2) {
                                        angle = 90 + ((2*(Double(Int(xPos*2))-0.5))*((rand() * -60)-45))
                                    } else if(xPos < 0.5) {
                                        xPos /= 2.3
                                        angle = rand() * 30 + 180
                                    } else {
                                        angle = rand() * -30
                                        xPos = 1 - ((1 - xPos) / 2.3)
                                    }
                                    EntityManager.addParticle(particle: Particle.init(x: x+xPos, y: y + ((rand() - 0.5) * 0.2), angle: angle, distance: 0.2 + (rand()*0.2), shape: 0, color: color, lifeTime: 0.3+(rand()*0.3), deathType: 0))
                                }*/
                                
                                let minShakeTime = 0.15
                                let maxShakeTime = 0.8
                                let minIntensity = 0.14
                                let maxIntensity = 1.0
                                
                                let maxFallingDistance = 15.0
                                let distance = GameState.heightAt(time: verticalMovementTimer)
                                let prog = pow(min(1, (distance / maxFallingDistance)), 2)
                                
                                Camera.shake(forTime: (prog*maxShakeTime)+((1-prog)*minShakeTime), withIntensity: (prog*maxIntensity)+((1-prog)*minIntensity), dropoff: true)
                            }
                            
                            nextY = entity.nextY - 1
                            yVel = 0
                            verticalMovementTimer = 0
                            
                            if(entity.isDangerous) {
                                //GameState.gameAction(type: "kill player")
                            }
                            //print(" hit ground, with block at \(Int(entity.x)), \(Int(entity.y))")
                        }
                    } else if(yVel < 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: (nextX + 0.5), y: (nextY - (sqrt(3.0) / 2.0)) + colAcc))) {
                            
                            nextY = entity.nextY + (sqrt(3.0) / 2.0) + 2*colAcc
                            yVel = 0
                            verticalMovementTimer = 0
                            
                            if(entity.isDangerous) {
                                //GameState.gameAction(type: "kill player")
                            }
                            //print(" hit ceiling, with block at \(Int(entity.x)), \(Int(entity.y))  xmod = \(xMod)")
                        }
                    } else if(yVel == 0) {
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1+colAcc, width: 1.0, height: 1.0), point: CGPoint(x: x + 1 - colAcc, y: nextY+colAcc))) {
                            
                            if(entity.isDangerous) {
                                //GameState.gameAction(type: "kill player")
                            }
                        }
                    }
                    /*if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: (nextX + 0.5), y: (nextY - (sqrt(3.0) / 2.0)) + colAcc)) ) {
                        
                        if(entity.name == "moving block" && (entity as! MovingBlock).falling && (entity as! MovingBlock).direction == Board.direction%2) {
                            GameState.gameAction(type: "kill player")
                        }
                    }*/
                }
            }
        }
    }
    
    func checkEastWestCollision() {
        for entity in nearbyEntities {
            
            //following code cotains collision instruction for blocks and moving blocks only, in the x direction
            if(entity.hitboxType == HitboxType.block || entity.hitboxType == HitboxType.movingBlock) {
                
                //make sure the player is able to collide with the current block or moving block by the collision rules defined by entity class
                if(Entity.collides(this: self, with: entity)) {
                    var xMod = 0.0
                    var yMod = 0.0
                    
                    let colAcc = 0.001
                    
                    //check for collision in multiple points throughout the edges of the player
                    let step = 50.0
                    
                    for posInEdge in stride(from: 0.0, through: 1.0, by: (1.0 / step)) {
                        xMod = posInEdge/2
                        yMod = posInEdge * (sqrt(3.0) / -2.0)
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: (nextX + xMod + colAcc), y: (nextY + yMod - colAcc))) && entity.nextX + 0.5 - colAcc < x) {
                            
                            if(entity.isDangerous) {
                                //GameState.gameAction(type: "kill player")
                            } else {
                                nextX = entity.nextX + 1 - xMod + colAcc
                                if(posInEdge <= 2.0 / step) {
                                    nextX = entity.nextX + 1
                                    if(entity.nextX == Double(Int(entity.nextX)) && entity.nextY == Double(Int(entity.nextY))) {
                                        canHingeLeft = true
                                    }
                                }
                            }
                            xVel = 0
                            //print(" hit edge, with block at \(Int(entity.nextX)), \(Int(entity.nextY))  xmod = \(xMod)")
                        }
                        if(rectContainsPoint(rect: CGRect.init(x: entity.nextX, y: entity.nextY-1, width: 1.0, height: 1.0), point: CGPoint(x: (nextX + 1 - xMod - colAcc), y: (nextY + yMod - colAcc))) && entity.nextX + 0.5 > x) {
                            
                            if(entity.isDangerous) {
                                //GameState.gameAction(type: "kill player")
                            } else {
                                nextX = entity.nextX - 1 + xMod - colAcc
                                if(posInEdge <= 2.0 / step) {
                                    nextX = entity.nextX - 1
                                    if(entity.nextX == Double(Int(entity.nextX)) && entity.nextY == Double(Int(entity.nextY))) {
                                        canHingeRight = true
                                    }
                                }
                            }
                            xVel = 0
                            //print(" hit edge, with block at \(Int(entity.nextX)), \(Int(entity.nextY))  xmod = \(xMod)")
                        }
                    }
                } else {
                    if(newColorIndex == -1) {
                        if(entity.name == "color change block" && Board.direction == (entity as! ColorChangeBlock).direction) {
                            if(nextY == Double(Int(nextY)) && ((x - colAcc <= entity.x && nextX + colAcc >= entity.x) || (x + colAcc >= entity.x && nextX - colAcc <= entity.x)) && ((y <= entity.y && nextY >= entity.y) || (y >= entity.y && nextY <= entity.y))) {
                                if((entity as! ColorChangeBlock).colorIndex != colorIndex) {
                                    nextX = entity.nextX
                                    xVel = 0
                                    horizontalMovementTimer = 0
                                    
                                    newColorIndex = (entity as! ColorChangeBlock).colorIndex
                                    
                                    GameState.gameAction(GameAction.changingColor)
                                }
                            }
                        } else if(entity.name == "exit block" && Board.direction == (entity as! ExitBlock).direction) {
                            if(nextY == Double(Int(nextY)) && ((x - colAcc <= entity.x && nextX + colAcc >= entity.x) || (x + colAcc >= entity.x && nextX - colAcc <= entity.x)) && ((y <= entity.y && nextY >= entity.y) || (y >= entity.y && nextY <= entity.y))) {
                                if((entity as! ExitBlock).colorIndex != colorIndex) {
                                    nextX = entity.nextX
                                    xVel = 0
                                    horizontalMovementTimer = 0
                                    
                                    newColorIndex = -2
                                    
                                    (entity as! ExitBlock).disable()
                                    GameState.gameAction(GameAction.endingStage)
                                }
                            }
                        }
                    }
                    /*if(entity.name == "block" && ((entity as! Block).type == 3 || (entity as! Block).type == 4 || (entity as! Block).type == 7 || (entity as! Block).type == 8 || (entity as! Block).type == 9) && Board.direction == (entity as! Block).direction) {
                        let b = entity as! Block
                        if(nextY == Double(Int(nextY)) && ((x - colAcc <= entity.x && nextX + colAcc >= entity.x) || (x + colAcc >= entity.x && nextX - colAcc <= entity.x)) && ((y <= entity.y && nextY >= entity.y) || (y >= entity.y && nextY <= entity.y)) && (Entity.collides(this: self, with: Board.blocks[Int(y+1)][Int(nextX+0.5)]!) || (Board.findMovingBlockAtPoint(x: Double(Int(nextX+0.5)), y: Double(Int(y+1))) != nil && Entity.collides(this: self, with: Board.findMovingBlockAtPoint(x: Double(Int(nextX+0.5)), y: Double(Int(y+1)))!))   )) {
                            if(b.type == 3 && b.colorIndex2 != colorIndex && !GameState.inverted && Player.currentAbilities.contains("changing color") && GameState.coloredBlocksVisible) {
                                nextX = entity.nextX
                                xVel = 0
                                horizontalMovementTimer = 0
                                
                                newColorIndex = b.colorIndex2
                                newColor = b.sprite2!.fillColor
                                GameState.gameAction(type: "change color")
                            } else if(b.type == 8 && b.colorIndex2 != colorIndex && GameState.inverted && Player.currentAbilities.contains("changing color") && GameState.coloredBlocksVisible) {
                                nextX = entity.nextX
                                xVel = 0
                                horizontalMovementTimer = 0
                                
                                newColorIndex = b.colorIndex2
                                newColor = b.sprite2!.fillColor
                                GameState.gameAction(type: "change color")
                            } else if(b.type == 4) {
                                nextX = entity.nextX
                                xVel = 0
                                horizontalMovementTimer = 0
                                
                                newColorIndex = -1
                                newColor = b.sprite.fillColor
                                GameState.exitTarget = b.exitTarget!
                                GameState.gameAction(type: "end stage")
                            } else if(b.type == 7 && (x != b.x || y != b.y) && Player.currentAbilities.contains("inverting")) {
                                nextX = entity.nextX
                                x = nextX
                                xVel = 0
                                horizontalMovementTimer = 0
                                updateSprite()
                                
                                GameState.gameAction(type: "invert")
                            } else if(b.type == 9 && (x != b.x || y != b.y) && !b.gainedAbility) {
                                nextX = entity.nextX
                                x = nextX
                                xVel = 0
                                horizontalMovementTimer = 0
                                updateSprite()
                                
                                GameState.gameAction(type: "gain ability")
                            }
                        }
                    }*/
                }
            }
        }
    }
}
