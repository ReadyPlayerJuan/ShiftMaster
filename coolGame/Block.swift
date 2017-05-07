//
//  Block.swift
//  Drawing Test
//
//  Created by Erin Seel on 11/25/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class Block: Entity {
    var colorIndex: Int = -1
    var colorIndex2: Int = -1
    var type: Int = 1
    var solid: Bool = true
    var direction: Int = 0
    var color: UIColor = UIColor.purple
    var color2: UIColor = UIColor.purple
    
    var sprite2: SKShapeNode?
    var inversionSprite: SKShapeNode?
    
    var hazardCycle = 15.0
    var colorProgressionBase = 0.0
    var previousColorProgression = 0.0
    
    var inverseColor: UIColor = UIColor.green
    var inverseColor2: UIColor = UIColor.purple
    
    var exitTarget: Int?
    
    var stageBreakawayDelay: Double!
    var stageBreakawayAngleVel: Double!
    
    
    
    //for ability gain animation
    var lightingInfo = [[Double]]()
    var lightSpawnCounter = 0.0
    var numLights = 0
    
    var addExplosionSprites = true
    var explosionSprites = [SKShapeNode]()
    var explosionSpriteInfo = [[Double]]()
    
    var gainedAbility = false
    
    
    init(blockType: Int, color: Int, secondaryColor: Int, dir: Int, x: Double, y: Double) {
        super.init()
        self.x = x
        self.y = y
        type = blockType
        
        isDynamic = false
        collidesWithType = [0]
        collisionPriority = 99
        name = "block"
        zPos = 1
        
        switch(type) {
        case 0: //black nonsolid block
            solid = false
            colorIndex = -1
            colorIndex2 = -1
            direction = -1
            collisionType = -1
            break
        case 1: //white solid block
            solid = true
            colorIndex = -1
            colorIndex2 = -1
            direction = -1
            collisionType = 0
            break
        case 2: //colored block
            solid = false
            colorIndex = color
            colorIndex2 = -1
            direction = -1
            collisionType = colorIndex + 10
            break
        case 3: //triangle block
            solid = false
            colorIndex = color
            colorIndex2 = secondaryColor
            direction = dir
            collisionType = colorIndex + 10
            break
        case 4: //end block
            solid = false
            colorIndex = color
            colorIndex2 = -1
            direction = dir
            if(direction == -1) {
                direction += 4
            }
            if(colorIndex == -1) {
                collisionType = -1
            } else {
                collisionType = colorIndex + 10
            }
            break
        case 5: //empty filler block
            solid = true
            colorIndex = -1
            colorIndex2 = -1
            direction = -1
            collisionType = 0
            break
        case 6: //hazard block
            solid = true
            colorIndex = -1
            colorIndex2 = -1
            direction = -1
            collisionType = 0
            isDangerous = true
            colorProgressionBase = x + y
            break
        case 7: //invert block
            solid = false
            colorIndex = color
            colorIndex2 = -1
            direction = dir
            if(colorIndex == -1) {
                collisionType = -1
            } else {
                collisionType = colorIndex + 10
            }
            break
        case 8: //hidden triangle block
            solid = false
            colorIndex = color
            colorIndex2 = secondaryColor
            direction = dir
            collisionType = colorIndex + 10
            break
        case 9: //gain ability block
            solid = false
            colorIndex = -1
            colorIndex2 = -1
            direction = dir
            collisionType = -1
        default: //white solid block
            solid = true
            colorIndex = -1
            colorIndex2 = -1
            direction = -1
            collisionType = 0
            break
        }
        
        initColor()
        loadSprite()
    }
    
    func addLighting() {
        EntityManager.addEntity(entity: LightSource.init(colorSource: self, xPos: x, yPos: y))
    }
    
    func reload() {
        initColor()
        loadSprite()
    }
    
    func loadColor(colorIndex: Int, type: Int, inverted: Bool, colorVariation: Bool) -> UIColor {
        var colorVar = 0.0
        if(colorVariation) {
            colorVar = Board.colorVariation
        }
        
        switch(type) {
        case 0: //grayscale
            if(colorIndex == -1) {
                let blockVariation = Int(rand()*colorVar)
                if(!inverted) {
                    return UIColor(red: 0.0+(CGFloat(blockVariation)/255.0), green: 0.0+(CGFloat(blockVariation)/255.0), blue: 0.0+(CGFloat(blockVariation)/255.0), alpha: 1.0)
                } else {
                    return UIColor(red: 1.0-(CGFloat(blockVariation)/255.0), green: 1.0-(CGFloat(blockVariation)/255.0), blue: 1.0-(CGFloat(blockVariation)/255.0), alpha: 1.0)
                }
            } else if(colorIndex == 0) {
                let blockVariation = Int(rand()*colorVar)
                if(!inverted) {
                    return UIColor(red: 1.0-(CGFloat(blockVariation)/255.0), green: 1.0-(CGFloat(blockVariation)/255.0), blue: 1.0-(CGFloat(blockVariation)/255.0), alpha: 1.0)
                } else {
                    return UIColor(red: 0.0+(CGFloat(blockVariation)/255.0), green: 0.0+(CGFloat(blockVariation)/255.0), blue: 0.0+(CGFloat(blockVariation)/255.0), alpha: 1.0)
                }
            }
            break
            
        case 1: //colors
            let blockVariation = Int((rand()*colorVar*2)-colorVar)
            var colorArray = ColorTheme.colors[Board.colorTheme][colorIndex]
            
            for index in 0 ... 2 {
                colorArray[index] = max(min(colorArray[index] + blockVariation, 255), 0)
            }
            
            if(!inverted) {
                return UIColor(red: CGFloat(colorArray[0]) / 255.0, green: CGFloat(colorArray[1]) / 255.0, blue: CGFloat(colorArray[2]) / 255.0, alpha: 1.0)
            } else {
                return UIColor(red: 1-(CGFloat(colorArray[0]) / 255.0), green: 1-(CGFloat(colorArray[1]) / 255.0), blue: 1-(CGFloat(colorArray[2]) / 255.0), alpha: 1.0)
            }
            
        default:
            break
        }
        
        return UIColor.purple
    }
    
    func initColor() {
        if(type == 0 || type == 1) {
            color = loadColor(colorIndex: type-1, type: 0, inverted: GameState.inverted, colorVariation: true)
            inverseColor = loadColor(colorIndex: type-1, type: 0, inverted: !GameState.inverted, colorVariation: true)
            
        } else if(type == 9) {
            color = loadColor(colorIndex: -1, type: 0, inverted: GameState.inverted, colorVariation: true)
            inverseColor = loadColor(colorIndex: -1, type: 0, inverted: !GameState.inverted, colorVariation: true)
            
        } else if(type == 2 || type == 3 || type == 8 || type == 4 || type == 7) {
            if(colorIndex != -1) {
                color = loadColor(colorIndex: colorIndex, type: 1, inverted: GameState.inverted, colorVariation: true)
                inverseColor = loadColor(colorIndex: colorIndex, type: 1, inverted: !GameState.inverted, colorVariation: true)
                
            } else {
                color = loadColor(colorIndex: -1, type: 0, inverted: GameState.inverted, colorVariation: true)
                inverseColor = loadColor(colorIndex: -1, type: 0, inverted: !GameState.inverted, colorVariation: true)
                
            }
            
            if(type == 3 || type == 8) {
                color2 = loadColor(colorIndex: colorIndex2, type: 1, inverted: GameState.inverted, colorVariation: false)
                inverseColor2 = loadColor(colorIndex: colorIndex2, type: 1, inverted: !GameState.inverted, colorVariation: false)
            } else if(type == 4) {
                
            }
        } else if(type == 5) {
            color = UIColor.clear
            inverseColor = UIColor.clear
        }
    }
    
    func updateColor() {
        if(type == 4) {
            let cycle = 1.0
            var b = GameState.time
            
            let a = Double(Int(b/cycle))*cycle
            let c = b - a
            b = c
            
            b /= cycle
            b *= 2
            b = b - 1
            b = pow(abs(b), 1.0)
            
            if(GameState.inverted) {
                color2 = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(b))
            } else {
                color2 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(b))
            }
        } else if(type == 6) {
            var c = colorProgressionBase + (EntityManager.getPlayer()! as! Player).movementTotal + (GameState.time / (2 * hazardCycle))
            
            if(GameState.state == "rotating") {
                let ang = abs(GameState.getRotationValue()) / (3.14159 / 2)
                c += hazardCycle * (1-ang)
            } else if(GameState.state == "resetting stage") {
                let ang = abs(GameState.getDeathRotation()) / (3.14159 / 2)
                c += hazardCycle * (1-ang) * ((Double(GameState.deathTimerMax) / Double(GameState.rotateTimerMax)) / 2.0)
            }
            
            let colorProgression = abs((remainder(c, hazardCycle) + (hazardCycle/2.0)) / hazardCycle) + (GameState.time / (2 * hazardCycle))
            
            var r = remainder(colorProgression + 0.0, 1.0) + 0.5
            var g = remainder(colorProgression + 0.333, 1.0) + 0.5
            var b = remainder(colorProgression + 0.666, 1.0) + 0.5
            r = abs((r * 2) - 1)
            g = abs((g * 2) - 1)
            b = abs((b * 2) - 1)
            
            let flickerTogether = true || false
            var rand = 0.0
            if(!flickerTogether) {
                rand = self.rand()
            } else {
                rand = GameState.globalRand
            }
            let flicker = (1 * (pow(rand * 0.9, 4) - 0.5) / 2) + 0.2
            r = min(1.0, max(0.0, r + flicker))
            g = min(1.0, max(0.0, g + flicker))
            b = min(1.0, max(0.0, b + flicker))
            
            color = UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
            inverseColor = UIColor.init(red: 1-CGFloat(r), green: 1-CGFloat(g), blue: 1-CGFloat(b), alpha: 1.0)
        } else if(type == 7) {
            let cycle = 2.0
            let numColors = ColorTheme.colors[Board.colorTheme].count
            var progression = GameState.time - Double(Int(GameState.time/cycle))*cycle
            progression -= (cycle/2.0)
            progression *= (2.0/cycle)
            let decreasing = (progression < 0)
            progression = abs(progression)
            progression *= Double(numColors-1)
            
            var currentColor = Int(progression)
            var nextColor = Int(progression)+1
            var colorProgression = progression - Double(Int(progression))
            if(decreasing) {
                currentColor += 1
                nextColor -= 1
                colorProgression = 1-colorProgression
            }
            if(currentColor >= 6) {
                currentColor = 5
            }
            
            var r = (Double(1-colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][currentColor][0])/255.0))
            r += (Double(colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][nextColor][0])/255.0))
            var g = (Double(1-colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][currentColor][1])/255.0))
            g += (Double(colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][nextColor][1])/255.0))
            var b = (Double(1-colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][currentColor][2])/255.0))
            b += (Double(colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][nextColor][2])/255.0))
            
            color2 = UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
            inverseColor2 = UIColor.init(red: 1-CGFloat(r), green: 1-CGFloat(g), blue: 1-CGFloat(b), alpha: 1.0)
        }
    }
    
    override func update(delta: TimeInterval) {
        super.update(delta: delta)
        updateSprite()
    }
    
    override func updateSprite() {
        if(GameState.state == "stage transition") {
            if(type == 4) {
                updateColor()
                
                sprite2!.fillColor = color2
                
                if(!GameState.enteringStage && EntityManager.getPlayer()!.x == x && EntityManager.getPlayer()!.y == y) {
                    sprite2!.alpha = 0.0
                }
            } else if(type == 6) {
                updateColor()
                
                if(GameState.inverted) {
                    sprite.fillColor = inverseColor
                } else {
                    sprite.fillColor = color
                }
            } else if(type == 7) {
                updateColor()
                
                if(GameState.inverted) {
                    sprite2!.fillColor = inverseColor2
                } else {
                    sprite2!.fillColor = color2
                }
            }
            
            if(!GameState.enteringStage) {
                switch(GameState.stageTransitionType) {
                case 0:
                    break
                case 1:
                    let time = GameState.stageTransitionTimerMax - GameState.stageTransitionTimer
                    
                    if(time > stageBreakawayDelay) {
                        x += xVel * GameState.currentDelta
                        
                        sprite.zRotation += CGFloat(stageBreakawayAngleVel * (time-stageBreakawayDelay))
                        let dx = Double((sqrt(2.0)/2)*cos(sprite.zRotation + (3.14159 * (5.0 / 4))))
                        let dy = Double((sqrt(2.0)/2)*sin(sprite.zRotation + (3.14159 * (5.0 / 4))))
                        
                        sprite.position = CGPoint.init(x: (x + 0.5 + dx) * Board.blockSize , y: ((-y - (GameState.heightAt(time: time-stageBreakawayDelay) - GameState.jumpHeight) + 0.5 + dy) * Board.blockSize))
                    }
                    break
                default:
                    break
                }
            }
        } else if(GameState.state == "inverting") {
            if(type == 7) {
                sprite2!.alpha = 0.0
            } else if(type == 6) {
                updateColor()
                
                if(GameState.inverted) {
                    let c = color
                    color = inverseColor
                    inverseColor = c
                }
                sprite.fillColor = color
            } else if(type == 4) {
                let cycle = 1.0
                var b = GameState.time
                
                let a = Double(Int(b/cycle))*cycle
                let c = b - a
                b = c
                
                b /= cycle
                b *= 2
                b = b - 1
                b = pow(abs(b), 1.0)
                
                var otherColor: UIColor!
                if(GameState.getInversionLinePosition() < x-1) {
                    sprite2!.alpha = 1
                    
                    if(GameState.inverted) {
                        otherColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(b))
                    } else {
                        otherColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(b))
                    }
                } else if(GameState.getInversionLinePosition() < x && GameState.getInversionLinePosition() >= x-1) {
                    sprite2!.alpha = 1-CGFloat(GameState.getInversionLinePosition()-(x-1))
                    
                    if(GameState.inverted) {
                        otherColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(b))
                    } else {
                        otherColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(b))
                    }
                } else if(GameState.getInversionLinePosition() <= x+1 && GameState.getInversionLinePosition() >= x) {
                    sprite2!.alpha = 0
                    
                    if(GameState.inverted) {
                        otherColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(b))
                    } else {
                        otherColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(b))
                    }
                } else if(GameState.getInversionLinePosition() > x+1 && GameState.getInversionLinePosition() <= x+2) {
                    sprite2!.alpha = 0+CGFloat(GameState.getInversionLinePosition()-(x+1))
                    
                    if(GameState.inverted) {
                        otherColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(b))
                    } else {
                        otherColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(b))
                    }
                } else if(GameState.getInversionLinePosition() > x+2) {
                    sprite2!.alpha = 1
                    
                    if(GameState.inverted) {
                        otherColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(b))
                    } else {
                        otherColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(b))
                    }
                }
                
                sprite2!.fillColor = otherColor
            } else if(type == 3 || type == 8) {
                if(GameState.getInversionLinePosition() < x-1) {
                    
                    if((type == 3 && !GameState.inverted) || (type == 8 && GameState.inverted)) {
                        sprite2!.alpha = 1
                    } else if((type == 8 && !GameState.inverted) || (type == 3 && GameState.inverted)) {
                        sprite2!.alpha = 0
                    }
                } else if(GameState.getInversionLinePosition() < x && GameState.getInversionLinePosition() >= x-1) {
                    
                    if((type == 3 && !GameState.inverted) || (type == 8 && GameState.inverted)) {
                        sprite2!.alpha = 1-CGFloat(GameState.getInversionLinePosition()-(x-1))
                    } else if((type == 8 && !GameState.inverted) || (type == 3 && GameState.inverted)) {
                        sprite2!.alpha = 0
                    }
                } else if(GameState.getInversionLinePosition() <= x+1 && GameState.getInversionLinePosition() >= x) {
                    sprite2!.alpha = 0
                } else if(GameState.getInversionLinePosition() > x+1 && GameState.getInversionLinePosition() <= x+2) {
                    
                    if((type == 3 && !GameState.inverted) || (type == 8 && GameState.inverted)) {
                        sprite2!.alpha = 0
                    } else if((type == 8 && !GameState.inverted) || (type == 3 && GameState.inverted)) {
                        sprite2!.alpha = 0+CGFloat(GameState.getInversionLinePosition()-(x+1))
                    }
                } else if(GameState.getInversionLinePosition() > x+2) {
                    
                    if((type == 3 && !GameState.inverted) || (type == 8 && GameState.inverted)) {
                        sprite2!.alpha = 0
                    } else if((type == 8 && !GameState.inverted) || (type == 3 && GameState.inverted)) {
                        sprite2!.alpha = 1
                    }
                }
            }
            
            
            if(GameState.getInversionLinePosition() <= x) {
                
            } else if(GameState.getInversionLinePosition() < x+1) {
                if(inversionSprite != nil) {
                    inversionSprite!.removeFromParent()
                }
                
                inversionSprite = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Board.blockSize * (GameState.getInversionLinePosition()-x), height: Board.blockSize))
                inversionSprite!.fillColor = inverseColor
                inversionSprite!.strokeColor = UIColor.clear
                sprite.addChild(inversionSprite!)
            } else {
                if(GameState.getPrevInversionLinePosition() < x+1) {
                    if(inversionSprite != nil) {
                        inversionSprite!.removeFromParent()
                    }
                    
                    inversionSprite = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Board.blockSize, height: Board.blockSize))
                    inversionSprite!.fillColor = inverseColor
                    inversionSprite!.strokeColor = UIColor.clear
                    sprite.addChild(inversionSprite!)
                } else {
                    if(inversionSprite != nil) {
                        inversionSprite!.fillColor = inverseColor
                    }
                }
            }
        } else if(GameState.state == "gaining ability") {
            
            if(type == 4) {
                updateColor()
                
                sprite2!.fillColor = color2
            } else if(type == 6) {
                updateColor()
                
                if(GameState.inverted) {
                    sprite.fillColor = inverseColor
                } else {
                    sprite.fillColor = color
                }
            } else if(type == 7) {
                updateColor()
                
                if(GameState.inverted) {
                    sprite2!.fillColor = inverseColor2
                } else {
                    sprite2!.fillColor = color2
                }
            } else if(type == 9) {
                
                let prog = 1-(GameState.gainAbilityTimer / GameState.gainAbilityTimerMax)
 
 
                if(sprite.children[0].alpha == 0.0) {
                    sprite.children[0].alpha = 1.0
                }
 
                for i in 0...sprite.children.count-1 {
                    if(sprite.children[i].name! == "rotate") {
                        let s = sprite.children[i] as! SKShapeNode
                        
                        if(prog < GameState.GAscreenFloodTimerMax) {
                            if(s.children.count == 0) {
                                if(i%2 == 0) {
                                    s.fillColor = UIColor.white
                                } else {
                                    s.fillColor = UIColor.black
                                }
                            }
                            
                            var rotateProg = (max(GameState.GArotateTimerMin, min(GameState.GArotateTimerMax, prog)) - GameState.GArotateTimerMin) / (GameState.GArotateTimerMax - GameState.GArotateTimerMin)
                            var shadeChangeProg = (max(GameState.GAshadeChangeTimerMin, min(GameState.GAshadeChangeTimerMax, prog)) - GameState.GAshadeChangeTimerMin) / (GameState.GAshadeChangeTimerMax - GameState.GAshadeChangeTimerMin)
                            
                            shadeChangeProg = pow(shadeChangeProg, 2)
                            
                            let secondHalf = (rotateProg > 0.5)
                            rotateProg *= 2
                            rotateProg -= 1
                            rotateProg = pow(1 - abs(rotateProg), 2)
                            if(secondHalf) {
                                rotateProg = 2 - rotateProg
                            }
                            rotateProg /= 2
                            
                            
                            let maxRotation = (2 * (Double((i+0) % 2) - 0.5)) * ((Double(2-i) * 9.0) + 15.0)
                            let shadowSkip = 4
                            let numShadows = (shadowSkip * 3) - 1
                            let maxAngleDifference = (120.0 / Double(numShadows + 1)) * (3.14159 / 180.0)
                            let finalShadowAlpha0 = 0.5
                            let finalShadowAlpha1 = 0.1
                            
                            for j in 0...numShadows-1 {
                                let angleDifference = maxAngleDifference * Double((numShadows-1-j) + 1) * pow(rotateProg, 1)
                                
                                if(s.children.count <= j) {
                                    let ns = s.copy() as! SKShapeNode
                                    ns.removeAllChildren()
                                    ns.position = CGPoint.init(x: 0, y: 0)
                                    ns.zPosition = CGFloat(-1 * (Double(j+1) * 0.01))
                                    
                                    if((j + 1) % ((numShadows+1) / shadowSkip) == 0) {
                                        ns.name = "brighter"
                                    } else {
                                        ns.name = "dimmer"
                                    }
                                    /*
                                     if(i%2 == 0) {
                                     ns.fillColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(1.0 / Double(numShadows + 1)))
                                     } else {
                                     ns.fillColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(1.0 / Double(numShadows + 1)))
                                     }*/
                                    
                                    s.addChild(ns)
                                }
                                
                                var finalShadowAlpha = finalShadowAlpha1
                                if((j + 1) % ((numShadows+1) / shadowSkip) == 0) {
                                    finalShadowAlpha = finalShadowAlpha0
                                }
                                
                                s.children[j].zRotation = CGFloat(angleDifference)
                                let alpha = CGFloat(((pow(Double(j + 1) / Double(numShadows + 1), 3)) * (1 - shadeChangeProg)) + (shadeChangeProg * finalShadowAlpha))
                                if(i%2 == 0) {
                                    (s.children[j] as! SKShapeNode).fillColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: alpha)
                                } else {
                                    (s.children[j] as! SKShapeNode).fillColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: alpha)
                                }
                            }
                            
                            s.zRotation = CGFloat(rotateProg * maxRotation * (3.14159 * (2.0 / 3.0)))
                        } else {
                            if(addExplosionSprites) {
                                s.alpha = 0.0
                                
                                let num = Double(i+1)
                                for r in 0...Int(num-1) {
                                    for c in 0...(r*2) {
                                        let distance = Board.blockSize * (sqrt(3.0)/3.0)
                                        var angle = 0.0
                                        
                                        if(i%2 == 1) {
                                            angle += 3.14159
                                        }
                                        
                                        
                                        if(c%2 == 0) {
                                            var center = CGPoint.init(x: Board.blockSize * (Double(c - r) / 2), y: (sqrt(3) / 2) * Board.blockSize * (((num-1)/2) - Double(r)) + ((1 - (sqrt(3)/2)) * Board.blockSize))
                                            if(i == 0) {
                                                center.y -= CGFloat((1 - (sqrt(3)/2)) * Board.blockSize)
                                            } else if(i == 2) {
                                                center.y += CGFloat((1 - (sqrt(3)/2)) * Board.blockSize)
                                            }
                                            var distanceFromCenter = 0.0
                                            var angleFromCenter = 0.0
                                            
                                            if(center.x == 0) {
                                                if(center.y == 0) {
                                                    distanceFromCenter = 0
                                                    angleFromCenter = 0
                                                } else {
                                                    if(center.y > 0) {
                                                        angleFromCenter = 3.14159 * (1.0 / 2)
                                                    } else {
                                                        angleFromCenter = 3.14159 * (3.0 / 2)
                                                    }
                                                    distanceFromCenter = hypot(Double(center.x), Double(center.y))
                                                }
                                            } else {
                                                angleFromCenter = Double(atan(center.y / center.x))
                                                if(center.x < 0) {
                                                    angleFromCenter += 3.14159
                                                }
                                                distanceFromCenter = hypot(Double(center.x), Double(center.y))
                                            }
                                            center = CGPoint.init(x: distanceFromCenter * cos(angleFromCenter + angle), y: distanceFromCenter * sin(angleFromCenter + angle))
                                            
                                            explosionSpriteInfo.append([angleFromCenter + angle, 0.0, distanceFromCenter, angle, 0.0, Double(i)])
                                            
                                            
                                            angle += 3.14159/2
                                            let path = UIBezierPath.init()
                                            path.move(to: CGPoint.init(x: distance * cos(angle + 0), y: distance * sin(angle + 0)))
                                            path.addLine(to: CGPoint.init(x: distance * cos(angle + (3.14159 * (2.0 / 3))), y: distance * sin(angle + (3.14159 * (2.0 / 3)))))
                                            path.addLine(to: CGPoint.init(x: distance * cos(angle + (3.14159 * (4.0 / 3))), y: distance * sin(angle + (3.14159 * (4.0 / 3)))))
                                            
                                            let sp = SKShapeNode.init(path: path.cgPath)
                                            sp.fillColor = s.fillColor
                                            sp.strokeColor = UIColor.clear
                                            sp.position = center
                                            sp.zPosition = s.zPosition
                                            explosionSprites.append(sp)
                                        } else if(c%2 == 1) {
                                            var center = CGPoint.init(x: Board.blockSize * (Double(c - r) / 2), y: (sqrt(3) / 2) * Board.blockSize * (((num-1)/2) - Double(r)) + ((1 - (sqrt(3)/2)) * Board.blockSize * 3) + 1.2)
                                            if(i == 2) {
                                                center.y += CGFloat((1 - (sqrt(3)/2)) * Board.blockSize)
                                            }
                                            var distanceFromCenter = 0.0
                                            var angleFromCenter = 0.0
                                            
                                            if(center.x == 0) {
                                                if(center.y == 0) {
                                                    distanceFromCenter = 0
                                                    angleFromCenter = 0
                                                } else {
                                                    if(center.y > 0) {
                                                        angleFromCenter = 3.14159 * (1.0 / 2)
                                                    } else {
                                                        angleFromCenter = 3.14159 * (3.0 / 2)
                                                    }
                                                    distanceFromCenter = hypot(Double(center.x), Double(center.y))
                                                }
                                            } else {
                                                angleFromCenter = Double(atan(center.y / center.x))
                                                if(center.x < 0) {
                                                    angleFromCenter += 3.14159
                                                }
                                                distanceFromCenter = hypot(Double(center.x), Double(center.y))
                                            }
                                            center = CGPoint.init(x: distanceFromCenter * cos(angleFromCenter + angle), y: distanceFromCenter * sin(angleFromCenter + angle))
                                            
                                            explosionSpriteInfo.append([angleFromCenter + angle, 0.0, distanceFromCenter, angle, 0.0, Double(i)])
                                            
                                            
                                            angle += 3.14159/2
                                            angle += 3.14159
                                            let path = UIBezierPath.init()
                                            path.move(to: CGPoint.init(x: distance * cos(angle + 0), y: distance * sin(angle + 0)))
                                            path.addLine(to: CGPoint.init(x: distance * cos(angle + (3.14159 * (2.0 / 3))), y: distance * sin(angle + (3.14159 * (2.0 / 3)))))
                                            path.addLine(to: CGPoint.init(x: distance * cos(angle + (3.14159 * (4.0 / 3))), y: distance * sin(angle + (3.14159 * (4.0 / 3)))))
                                            
                                            let sp = SKShapeNode.init(path: path.cgPath)
                                            sp.fillColor = s.fillColor
                                            sp.strokeColor = UIColor.clear
                                            sp.position = center
                                            sp.zPosition = s.zPosition
                                            explosionSprites.append(sp)
                                        }
                                    }
                                }
                                
                                for j in 0...s.children.count-1 {
                                    if(s.children[j].name! == "brighter") {
                                    
                                        s.children[j].alpha = 0.0
                                        
                                        for r in 0...Int(num-1) {
                                            for c in 0...(r*2) {
                                                let distance = Board.blockSize * (sqrt(3.0)/3.0)
                                                var angle = Double(s.children[j].zRotation)
                                                
                                                if(i%2 == 1) {
                                                    angle += 3.14159
                                                }
                                                
                                                
                                                if(c%2 == 0) {
                                                    var center = CGPoint.init(x: Board.blockSize * (Double(c - r) / 2), y: (sqrt(3) / 2) * Board.blockSize * (((num-1)/2) - Double(r)) + ((1 - (sqrt(3)/2)) * Board.blockSize))
                                                    if(i == 0) {
                                                        center.y -= CGFloat((1 - (sqrt(3)/2)) * Board.blockSize)
                                                    } else if(i == 2) {
                                                        center.y += CGFloat((1 - (sqrt(3)/2)) * Board.blockSize)
                                                    }
                                                    var distanceFromCenter = 0.0
                                                    var angleFromCenter = 0.0
                                                    
                                                    if(center.x == 0) {
                                                        if(center.y == 0) {
                                                            distanceFromCenter = 0
                                                            angleFromCenter = 0
                                                        } else {
                                                            if(center.y > 0) {
                                                                angleFromCenter = 3.14159 * (1.0 / 2)
                                                            } else {
                                                                angleFromCenter = 3.14159 * (3.0 / 2)
                                                            }
                                                            distanceFromCenter = hypot(Double(center.x), Double(center.y))
                                                        }
                                                    } else {
                                                        angleFromCenter = Double(atan(center.y / center.x))
                                                        if(center.x < 0) {
                                                            angleFromCenter += 3.14159
                                                        }
                                                        distanceFromCenter = hypot(Double(center.x), Double(center.y))
                                                    }
                                                    center = CGPoint.init(x: distanceFromCenter * cos(angleFromCenter + angle), y: distanceFromCenter * sin(angleFromCenter + angle))
                                                    
                                                    explosionSpriteInfo.append([angleFromCenter + angle, 0.0, distanceFromCenter, angle, 0.0, Double(i)])
                                                    
                                                    
                                                    angle += 3.14159/2
                                                    let path = UIBezierPath.init()
                                                    path.move(to: CGPoint.init(x: distance * cos(angle + 0), y: distance * sin(angle + 0)))
                                                    path.addLine(to: CGPoint.init(x: distance * cos(angle + (3.14159 * (2.0 / 3))), y: distance * sin(angle + (3.14159 * (2.0 / 3)))))
                                                    path.addLine(to: CGPoint.init(x: distance * cos(angle + (3.14159 * (4.0 / 3))), y: distance * sin(angle + (3.14159 * (4.0 / 3)))))
                                                    
                                                    let sp = SKShapeNode.init(path: path.cgPath)
                                                    sp.fillColor = (s.children[j] as! SKShapeNode).fillColor
                                                    sp.strokeColor = UIColor.clear
                                                    sp.position = center
                                                    sp.zPosition = s.zPosition
                                                    explosionSprites.append(sp)
                                                } else if(c%2 == 1) {
                                                    var center = CGPoint.init(x: Board.blockSize * (Double(c - r) / 2), y: (sqrt(3) / 2) * Board.blockSize * (((num-1)/2) - Double(r)) + ((1 - (sqrt(3)/2)) * Board.blockSize * 3) + 1.2)
                                                    if(i == 2) {
                                                        center.y += CGFloat((1 - (sqrt(3)/2)) * Board.blockSize)
                                                    }
                                                    var distanceFromCenter = 0.0
                                                    var angleFromCenter = 0.0
                                                    
                                                    if(center.x == 0) {
                                                        if(center.y == 0) {
                                                            distanceFromCenter = 0
                                                            angleFromCenter = 0
                                                        } else {
                                                            if(center.y > 0) {
                                                                angleFromCenter = 3.14159 * (1.0 / 2)
                                                            } else {
                                                                angleFromCenter = 3.14159 * (3.0 / 2)
                                                            }
                                                            distanceFromCenter = hypot(Double(center.x), Double(center.y))
                                                        }
                                                    } else {
                                                        angleFromCenter = Double(atan(center.y / center.x))
                                                        if(center.x < 0) {
                                                            angleFromCenter += 3.14159
                                                        }
                                                        distanceFromCenter = hypot(Double(center.x), Double(center.y))
                                                    }
                                                    center = CGPoint.init(x: distanceFromCenter * cos(angleFromCenter + angle), y: distanceFromCenter * sin(angleFromCenter + angle))
                                                    
                                                    explosionSpriteInfo.append([angleFromCenter + angle, 0.0, distanceFromCenter, angle, 0.0, Double(i)])
                                                    
                                                    
                                                    angle += 3.14159/2
                                                    angle += 3.14159
                                                    let path = UIBezierPath.init()
                                                    path.move(to: CGPoint.init(x: distance * cos(angle + 0), y: distance * sin(angle + 0)))
                                                    path.addLine(to: CGPoint.init(x: distance * cos(angle + (3.14159 * (2.0 / 3))), y: distance * sin(angle + (3.14159 * (2.0 / 3)))))
                                                    path.addLine(to: CGPoint.init(x: distance * cos(angle + (3.14159 * (4.0 / 3))), y: distance * sin(angle + (3.14159 * (4.0 / 3)))))
                                                    
                                                    let sp = SKShapeNode.init(path: path.cgPath)
                                                    sp.fillColor = (s.children[j] as! SKShapeNode).fillColor
                                                    sp.strokeColor = UIColor.clear
                                                    sp.position = center
                                                    sp.zPosition = s.zPosition
                                                    explosionSprites.append(sp)
                                                }
                                            }
                                        }
                                    } else {
                                        let sp = s.children[j].copy() as! SKShapeNode
                                        sp.position = CGPoint.init(x: 0, y: 0)
                                        sp.removeAllChildren()
                                        if(sp.parent != nil) {
                                            sp.removeFromParent()
                                        }
                                        explosionSpriteInfo.append([0, 0, 0, 0, 0, 0])
                                        explosionSprites.append(sp)
                                    }
                                }
                            }
                        }
                    } else if(sprite.children[i].name! == "light") {
                        let maxLightsPerSecond = 40.0
                        let totalAngleMovementAverage = 300.0
                        let totalAngleMovementVariation = 180.0
                        let maxAngleRange = 30.0
                        let minAlpha = 0.15
                        let maxAlpha = 0.30
                        let timeToMaxRange = 0.12
                        
                        var lightSpawnProg = (max(GameState.GAspinningLightTimerMin, min(GameState.GAspinningLightTimerMax, prog)) - GameState.GAspinningLightTimerMin) / (GameState.GAspinningLightTimerMax - GameState.GAspinningLightTimerMin)
                        lightSpawnProg = pow(lightSpawnProg, 2.0)
                        
                        if(lightSpawnProg < 1) {
                            lightSpawnCounter += lightSpawnProg * maxLightsPerSecond * GameState.currentDelta
                        }
                        
                        if(lightingInfo.count == 0 && lightSpawnCounter == 0) {
                            lightSpawnCounter += 0.5
                        }
                        
                        while(lightSpawnCounter >= 1) {
                            lightSpawnCounter -= 1
                            numLights += 1
                            
                            lightingInfo.append([rand() * 360, 0])
                            
                            if(rand() < 0.5) {
                                lightingInfo[lightingInfo.count-1].append(lightingInfo[lightingInfo.count-1][0] + totalAngleMovementAverage + (rand() * totalAngleMovementVariation * 2) - totalAngleMovementVariation)
                            } else {
                                lightingInfo[lightingInfo.count-1].append(lightingInfo[lightingInfo.count-1][0] - totalAngleMovementAverage + (rand() * totalAngleMovementVariation * 2) - totalAngleMovementVariation)
                            }
                            
                            lightingInfo[lightingInfo.count-1].append(prog)
                        }
                        
                        
                        var lightMovementProg = (max(GameState.GAspinningLightTimerMin, min(GameState.GAspinningLightTimerMax, prog)) - GameState.GAspinningLightTimerMin) / (GameState.GAspinningLightTimerMax - GameState.GAspinningLightTimerMin)
                        lightMovementProg = pow(lightMovementProg, 2)
                        
                        
                        sprite.children[i].removeAllChildren()
                        
                        if(lightSpawnProg < 1) {
                            if(numLights > 0) {
                                let length = 2.0 * Double(hypot(GameState.screenWidth/2, GameState.screenHeight/2))
                                for j in 0...numLights-1 {
                                    
                                    let angle = (lightingInfo[j][0] * (1 - lightMovementProg)) + (lightMovementProg * lightingInfo[j][2])
                                    let lightAngleRange = ((lightMovementProg * 0.7) + 0.3) * maxAngleRange
                                    let angleRange = min(1, (prog - lightingInfo[j][3]) / timeToMaxRange) * lightAngleRange
                                    
                                    if(angleRange > 0) {
                                        let path = UIBezierPath.init()
                                        path.move(to: CGPoint.init(x: 0, y: 0))
                                        path.addLine(to: CGPoint.init(x: length*cos((angle - angleRange/2) * (3.14159 / 180.0)), y: length*sin((angle - angleRange/2) * (3.14159 / 180.0))))
                                        path.addLine(to: CGPoint.init(x: length*cos((angle + angleRange/2) * (3.14159 / 180.0)), y: length*sin((angle + angleRange/2) * (3.14159 / 180.0))))
                                        
                                        let s = SKShapeNode.init(path: path.cgPath)
                                        s.fillColor = UIColor.white
                                        s.strokeColor = UIColor.clear
                                        s.alpha = CGFloat((minAlpha * (1 - lightSpawnProg)) + (maxAlpha * lightSpawnProg))
                                        sprite.children[i].addChild(s)
                                    }
                                }
                            }
                        } else {
                            lightingInfo = [[Double]]()
                            numLights = 0
                        }
                    } else if(sprite.children[i].name! == "screen") {
                        var screenFloodProg = (max(GameState.GAscreenFloodTimerMin, min(GameState.GAscreenFloodTimerMax, prog)) - GameState.GAscreenFloodTimerMin) / (GameState.GAscreenFloodTimerMax - GameState.GAscreenFloodTimerMin)
                        screenFloodProg = 1 - pow(1 - screenFloodProg, 2)
                        var reverseScreenFloodProg = (max(GameState.GAscreenFloodTimerMin2, min(GameState.GAscreenFloodTimerMax2, prog)) - GameState.GAscreenFloodTimerMin2) / (GameState.GAscreenFloodTimerMax2 - GameState.GAscreenFloodTimerMin2)
                        reverseScreenFloodProg = 1 - pow(1 - reverseScreenFloodProg, 2)
                        
                        if(screenFloodProg < 1) {
                            sprite.children[i].alpha = CGFloat(screenFloodProg)
                        } else if(reverseScreenFloodProg == 0) {
                            if(!addExplosionSprites) {
                                addExplosionSprites = true
                                explosionSprites = [SKShapeNode]()
                                explosionSpriteInfo = [[Double]]()
                            } else {
                                
                            }
                        } else if(reverseScreenFloodProg < 1) {
                            sprite.children[i].alpha = CGFloat(1 - reverseScreenFloodProg)
                        } else {
                            sprite.children[i].alpha = 0.0
                        }
                    } else if(sprite.children[i].name! == "explosion") {
                        let s = sprite.children[i] as! SKShapeNode
                        
                        //explosionSpriteInfo:
                        //              0                          1                        2                  3                    4             5
                        // starting angle from center   ending angle from center    starting distance   starting rotation    ending rotation    delay
                        
                        let maxDistanceBase = 1.3 * Board.blockSize
                        let maxDistanceScale = 0.7
                        let maxDelay = 0.4
                        let angleChange = 3.14159 * (2.3)
                        let maxRotation = 3.14159 * 2 * 3
                        
                        if(explosionSprites.count > 0 && s.children.count == 0) {
                            var numMovingSprites = 0
                            
                            for j in 0...explosionSprites.count-1 {
                                if(!(explosionSpriteInfo[j][2] < Board.blockSize * 0.2)) {
                                    numMovingSprites += 1
                                    
                                    if(explosionSpriteInfo[j][0] < 0) {
                                        explosionSpriteInfo[j][0] += (3.14159 * 2)
                                    }
                                    if(explosionSpriteInfo[j][0] > (3.14159 * 2)) {
                                        explosionSpriteInfo[j][0] -= (3.14159 * 2)
                                    }
                                }
                            }
                            
                            var sortedSprites = [SKShapeNode]()
                            var sortedSpriteInfo = [[Double]]()
                            
                            for j in 0...explosionSprites.count-1 {
                                var index = 0
                                if(sortedSprites.count > 0) {
                                    while(index < sortedSprites.count && sortedSpriteInfo[index][0] < explosionSpriteInfo[j][0]) {
                                        index += 1
                                    }
                                }
                                
                                sortedSprites.insert(explosionSprites[j], at: index)
                                sortedSpriteInfo.insert(explosionSpriteInfo[j], at: index)
                            }
                            
                            explosionSprites = sortedSprites
                            explosionSpriteInfo = sortedSpriteInfo
                            
                            var count = 0
                            for j in 0...explosionSprites.count-1 {
                                s.addChild(explosionSprites[j])
                                
                                var angle = 0.0
                                if(!(explosionSpriteInfo[j][2] < Board.blockSize * 0.2)) {
                                    angle = (Double(count) / Double(numMovingSprites)) * 360.0
                                    
                                    let n = 2
                                    while(angle > Double(360 / n)) {
                                        angle -= Double(360 / n)
                                    }
                                    angle *= Double(n)
                                    
                                    count += 1
                                }
                                
                                explosionSpriteInfo[j][5] = (1.0 + (rand() * 0.0)) * (pow((angle / 360.0), 1.0))
                                explosionSpriteInfo[j][1] = explosionSpriteInfo[j][0] + ((1.0 + (rand() * 0.0)) * angleChange)
                                explosionSpriteInfo[j][3] = maxRotation
                            }
                        }
                        
                        if(explosionSprites.count > 0) {
                            let explosionProg = (max(GameState.GAexplosionTimerMin, min(GameState.GAexplosionTimerMax, prog)) - GameState.GAexplosionTimerMin) / (GameState.GAexplosionTimerMax - GameState.GAexplosionTimerMin)
                            
                            for j in 0...explosionSprites.count-1 {
                                let sp = explosionSprites[j]
                                let info = explosionSpriteInfo[j]
                                
                                if(!(info[2] < Board.blockSize * 0.2)) {
                                    let delay = (info[5]) * maxDelay
                                    //print(delay)
                                    var movementProg = (max(delay, min(1 - maxDelay + delay, explosionProg)) - delay) / (1 - maxDelay)
                                    let angleProg = movementProg
                                    var rotationProg = movementProg
                                    rotationProg = pow(rotationProg, 2)
                                    
                                    /*
                                    let bh = rotationProg > 0.5
                                    rotationProg = abs((rotationProg * 2) - 1)
                                    rotationProg = pow(rotationProg, 1.4)
                                    if(!bh) {
                                        rotationProg  = (1 - rotationProg) / 2
                                    } else {
                                        rotationProg = (rotationProg/2) + 0.5
                                    }*/
                                    
                                    let angle = ((1 - angleProg) * info[0]) + (angleProg * info[1])
                                    
                                    var distance = 0.0
                                    if(movementProg <= 0.5) {
                                        movementProg = 1 - pow(1 - (movementProg*2), 2)
                                        distance = ((1 - movementProg) * info[2]) + (movementProg * ((maxDistanceScale * info[2]) + maxDistanceBase))
                                    } else {
                                        movementProg = 1 - pow((movementProg - 0.5)*2, 2)
                                        distance = (movementProg * ((maxDistanceScale * info[2]) + maxDistanceBase))
                                    }
                                    
                                    sp.alpha = CGFloat(min(1, (1 - rotationProg) * 2))
                                    sp.zRotation = CGFloat((rotationProg * (maxRotation)) + info[3])
                                    sp.position = CGPoint.init(x: distance*cos(angle), y: distance*sin(angle))
                                } else {
                                    let unGlowProg = (max(GameState.GAexplosionTimerMax, min(1.0, prog)) - GameState.GAexplosionTimerMax) / (1.0 - GameState.GAexplosionTimerMax)
                                    let glowProg = (min(1, explosionProg) - (1 - maxDelay)) / (1 - (1 - maxDelay))
                                    
                                    if(explosionProg < 1 - maxDelay) {
                                        sp.alpha = CGFloat(max(0, 1 - (explosionProg * 4)))
                                    } else if(unGlowProg > 0) {
                                        sp.alpha = CGFloat(1 - pow(unGlowProg, 2))
                                    } else {
                                        sp.alpha = CGFloat(1 - pow(1 - glowProg, 2))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        } else {
            
            if(type == 4) {
                updateColor()
                
                sprite2!.fillColor = color2
            } else if(type == 6) {
                updateColor()
                
                if(GameState.inverted) {
                    sprite.fillColor = inverseColor
                } else {
                    sprite.fillColor = color
                }
            } else if(type == 7) {
                updateColor()
                
                if(GameState.inverted) {
                    sprite2!.fillColor = inverseColor2
                } else {
                    sprite2!.fillColor = color2
                }
            } else if(type == 9) {
                if(sprite.children.count > 1 && !gainedAbility) {
                    let cycle = 2.0
                    
                    for i in 1...sprite.children.count-1 {
                        var prog = remainder(GameState.time + (Double(i) * (cycle / 1.0)), cycle)
                        prog += (cycle/2)
                        prog /= cycle
                        
                        prog *= 2
                        prog -= 1
                        prog = abs(prog)
                        
                        let a = 0.2
                        prog *= (1-a)
                        prog += a
                        
                        let variationMax = 0.4
                        
                        if(i == 1) {
                            let variation = variationMax * pow(rand(), 4)
                            
                            var color: [CGFloat] = [0.0, 0.0, 0.0]
                            for j in 0...color.count-1 {
                                color[j] += CGFloat(variation * prog)
                            }
                            (sprite.children[i] as! SKShapeNode).fillColor = UIColor.init(red: color[0], green: color[1], blue: color[2], alpha: 1.0)
                        } else if(i == 2) {
                            let variation = (variationMax * pow(1 - rand(), 4))
                            
                            var color: [CGFloat] = [1.0, 1.0, 1.0]
                            for j in 0...color.count-1 {
                                color[j] -= CGFloat(variation * prog)
                            }
                            (sprite.children[i] as! SKShapeNode).fillColor = UIColor.init(red: color[0], green: color[1], blue: color[2], alpha: 1.0)
                        }
                    }
                }
            }
        }
    }
    
    func differenceBetweenDegrees(a1: Double, a2: Double) -> Double {
        let n = min(abs((a1 + 360) - (a2 + 0)), abs((a1 + 0) - (a2 + 360)))
        return min(abs((a1 + 0) - (a2 + 0)), n)
    }
    
    func finishInversion() {
        let c1 = color
        color = inverseColor
        inverseColor = c1
        let c2 = color2
        color2 = inverseColor2
        inverseColor2 = c2
        
        sprite.removeAllChildren()
        if(type == 3) {
            sprite2!.removeAllChildren()
        }
        if(sprite2 != nil) {
            sprite.addChild(sprite2!)
        }
        
        loadSprite()
        updateSprite()
    }
    
    override func loadSprite() {
        if(type == 0 || type == 1 || type == 2 || type == 5 || type == 6) {
            let s = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Board.blockSize, height: Board.blockSize))
            s.position = CGPoint(x: x*Board.blockSize, y: -y*Board.blockSize)
            s.fillColor = color
            s.strokeColor = UIColor.clear
            s.zPosition = zPos + CGFloat(rand())
            self.sprite = s
        } else if(type == 3 || type == 4 || type == 7 || type == 8) {
            
            var point = CGPoint()
            point = CGPoint(x: x, y: y);
            
            var k = Board.direction - direction
            k %= 4
            if(k < 0) {
                k += 4
            }
            
            let unmodified = CGPoint(x: x, y: y)
            
            switch(k) {
            case 0:
                point = CGPoint(x: 0, y: 0); break
            case 1:
                point = CGPoint(x: 0, y: 0 - 1); break
            case 2:
                point = CGPoint(x: 0 + 1, y: 0 - 1); break
            case 3:
                point = CGPoint(x: 0 + 1, y: 0); break
            default:
                point = CGPoint(x: 0, y: 0); break
            }
            
            if(type == 4) {
                let s = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Board.blockSize, height: Board.blockSize))
                s.position = CGPoint(x: unmodified.x*CGFloat(Board.blockSize), y: -unmodified.y*CGFloat(Board.blockSize))
                s.fillColor = color
                s.strokeColor = UIColor.clear
                s.zPosition = zPos + CGFloat(rand())
                
                let s2 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: 0, y: 0), rotation: -90.0 * Double(Board.direction - direction), size: Board.blockSize))
                s2.position = CGPoint(x: point.x*CGFloat(Board.blockSize), y: -point.y*CGFloat(Board.blockSize))
                //s2.fillColor = UIColor.purple //color is set in updateSprite()
                s2.strokeColor = UIColor.clear
                s2.zPosition = 0.01
                
                s.addChild(s2)
                self.sprite = s
                self.sprite2 = s2
                
                updateSprite()
            } else if(type == 7) {
                let s = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Board.blockSize, height: Board.blockSize))
                s.position = CGPoint(x: unmodified.x*CGFloat(Board.blockSize), y: -unmodified.y*CGFloat(Board.blockSize))
                s.fillColor = color
                s.strokeColor = UIColor.clear
                s.zPosition = zPos + CGFloat(rand())
                
                let s2 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: 0, y: 0), rotation: -90.0 * Double(Board.direction - direction), size: Board.blockSize))
                s2.position = CGPoint(x: point.x*CGFloat(Board.blockSize), y: -point.y*CGFloat(Board.blockSize))
                //s2.fillColor = UIColor.purple //color is set in updateSprite()
                s2.strokeColor = UIColor.clear
                s2.zPosition = 0.01
                
                s.addChild(s2)
                self.sprite = s
                self.sprite2 = s2
                
                updateSprite()
            } else {
                let s = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Board.blockSize, height: Board.blockSize))
                s.position = CGPoint(x: unmodified.x*CGFloat(Board.blockSize), y: -unmodified.y*CGFloat(Board.blockSize))
                s.fillColor = color
                s.strokeColor = UIColor.clear
                s.zPosition = zPos + CGFloat(rand())
                
                let s2 = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: 0, y: 0), rotation: -90.0 * Double(Board.direction - direction), size: Board.blockSize))
                s2.position = CGPoint(x: point.x*CGFloat(Board.blockSize), y: -point.y*CGFloat(Board.blockSize))
                s2.strokeColor = UIColor.clear
                if((type == 8 && !GameState.inverted) || (type == 3 && GameState.inverted)) {
                    s2.fillColor = inverseColor2
                } else {
                    s2.fillColor = color2
                }
                s2.zPosition = 0.01
                if((GameState.inverted && type == 3) || (!GameState.inverted && type == 8)) {
                    s2.alpha = 0.0
                } else {
                    s2.alpha = 1.0
                }
                
                s.addChild(s2)
                self.sprite = s
                self.sprite2 = s2
            }
        } else if(type == 9) {
            let angle = (Double(Board.direction * -90) + 270.0) * (3.14159 / 180.0)
            let d = -0.5 + (sqrt(3) / 3) + (1 - (sqrt(3)/2))
            let dx = d*cos(angle)
            let dy = -d*sin(angle)
            let center = CGPoint.init(x: (x + dx + 0.5) * Board.blockSize, y: -(y + dy - 0.5) * Board.blockSize)
            
            sprite = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: Board.blockSize, height: Board.blockSize))
            sprite.position = CGPoint(x: x*Board.blockSize, y: -y*Board.blockSize)
            sprite.fillColor = color
            sprite.strokeColor = UIColor.clear
            sprite.zPosition = zPos + CGFloat(rand())
            
            if(!gainedAbility) {
                
                var distance = (1.0 * (sqrt(3.0) / 3)) * Board.blockSize
                var startAngle = -30.0 - (90.0 * Double(Board.direction))
                var path = UIBezierPath.init()
                
                path.move(to: CGPoint.init(x: distance * cos((startAngle) * (3.14159 / 180.0)), y: distance * sin((startAngle) * (3.14159 / 180.0))))
                path.addLine(to: CGPoint.init(x: distance * cos((startAngle + 120) * (3.14159 / 180.0)), y: distance * sin((startAngle + 120) * (3.14159 / 180.0))))
                path.addLine(to: CGPoint.init(x: distance * cos((startAngle + 240) * (3.14159 / 180.0)), y: distance * sin((startAngle + 240) * (3.14159 / 180.0))))
                
                var s = SKShapeNode.init(path: path.cgPath)
                s.position = CGPoint.init(x: center.x - sprite.position.x, y: center.y - sprite.position.y)
                s.alpha = 0.0
                s.fillColor = UIColor.white
                s.strokeColor = UIColor.clear
                s.zPosition = 7
                s.name = "rotate"
                
                sprite.addChild(s)
                
                
                distance = (2.0 * (sqrt(3.0) / 3)) * Board.blockSize
                startAngle = -90.0 - (90.0 * Double(Board.direction))
                path = UIBezierPath.init()
                
                path.move(to: CGPoint.init(x: distance * cos((startAngle) * (3.14159 / 180.0)), y: distance * sin((startAngle) * (3.14159 / 180.0))))
                path.addLine(to: CGPoint.init(x: distance * cos((startAngle + 120) * (3.14159 / 180.0)), y: distance * sin((startAngle + 120) * (3.14159 / 180.0))))
                path.addLine(to: CGPoint.init(x: distance * cos((startAngle + 240) * (3.14159 / 180.0)), y: distance * sin((startAngle + 240) * (3.14159 / 180.0))))
                
                s = SKShapeNode.init(path: path.cgPath)
                s.position = CGPoint.init(x: center.x - sprite.position.x, y: center.y - sprite.position.y)
                s.fillColor = UIColor.black
                s.strokeColor = UIColor.clear
                s.zPosition = 6
                s.name = "rotate"
                
                sprite.addChild(s)
                
                
                distance = (3.0 * (sqrt(3.0) / 3)) * Board.blockSize
                startAngle = -30.0 - (90.0 * Double(Board.direction))
                path = UIBezierPath.init()
                
                path.move(to: CGPoint.init(x: distance * cos((startAngle) * (3.14159 / 180.0)), y: distance * sin((startAngle) * (3.14159 / 180.0))))
                path.addLine(to: CGPoint.init(x: distance * cos((startAngle + 120) * (3.14159 / 180.0)), y: distance * sin((startAngle + 120) * (3.14159 / 180.0))))
                path.addLine(to: CGPoint.init(x: distance * cos((startAngle + 240) * (3.14159 / 180.0)), y: distance * sin((startAngle + 240) * (3.14159 / 180.0))))
                
                s = SKShapeNode.init(path: path.cgPath)
                s.position = CGPoint.init(x: center.x - sprite.position.x, y: center.y - sprite.position.y)
                s.fillColor = UIColor.white
                s.strokeColor = UIColor.clear
                s.zPosition = 5
                s.name = "rotate"
                
                sprite.addChild(s)
                
                
                s = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: 1, height: 1))
                s.position = CGPoint.init(x: center.x - sprite.position.x, y: center.y - sprite.position.y)
                s.fillColor = UIColor.clear
                s.strokeColor = UIColor.clear
                s.zPosition = 4
                s.name = "light"
                
                sprite.addChild(s)
                
                
                s = SKShapeNode.init(rect: CGRect.init(x: -GameState.screenWidth/2, y: -GameState.screenHeight/2, width: GameState.screenWidth, height: GameState.screenHeight))
                s.position = CGPoint.init(x: center.x - sprite.position.x, y: CGFloat(0.5 * Board.blockSize))
                s.fillColor = UIColor.white
                s.strokeColor = UIColor.clear
                s.alpha = 0.0
                s.zPosition = 999
                s.name = "screen"
                
                sprite.addChild(s)
                
                
                s = SKShapeNode.init(rect: CGRect.init(x: 0, y: 0, width: 1, height: 1))
                s.position = CGPoint.init(x: center.x - sprite.position.x, y: center.y - sprite.position.y)
                s.fillColor = UIColor.clear
                s.strokeColor = UIColor.clear
                s.zPosition = 5
                s.name = "explosion"
                
                sprite.addChild(s)
            }
        }
    }
    
    func beginInversion() {
        inversionSprite = SKShapeNode.init()
        sprite.addChild(inversionSprite!)
    }
    
    func beginStageBreakaway() {
        var n = 1.8
        xVel = (rand() * n * 2) - n
        yVel = 0
        
        n = 1.5
        stageBreakawayDelay = n * ((1 - (y / Double(Board.blocks.count))) * (1 - pow(rand(), 3.5)))
        
        n = 0.3
        stageBreakawayAngleVel = (rand() * n * 2) - n
    }
}
