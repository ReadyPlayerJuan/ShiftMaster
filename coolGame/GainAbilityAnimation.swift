//
//  GainAbilityAnimation.swift
//  coolGame
//
//  Created by Nick Seel on 5/7/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit
/*
extension Block {
    func updateGainAbilityAnimation() {
        
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
                    
                    var colorShade = 0.0
                    if(Block.abilityGainAnimationNum == 1) {
                        colorShade = max(0, min(1, (rotateProg * 1.5) - 0.2))
                    }
                    
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
                        
                        let currentColor = 1 + ((rotateProg * 2.0) - 0.0) + (Double(i) / 8.0) + ((1 - (Double(j) / Double(numShadows))) / 8.0)
                        if(i%2 == 0) {
                            (s.children[j] as! SKShapeNode).fillColor = UIColor.init(red: CGFloat(1 - colorShade) + (getRainbowColor(prog: currentColor)[0] * CGFloat(colorShade)), green: CGFloat(1 - colorShade) + (getRainbowColor(prog: currentColor)[1] * CGFloat(colorShade)), blue: CGFloat(1 - colorShade) + (getRainbowColor(prog: currentColor)[2] * CGFloat(colorShade)), alpha: alpha)
                        } else {
                            (s.children[j] as! SKShapeNode).fillColor = UIColor.init(red: (getRainbowColor(prog: currentColor)[0] * CGFloat(colorShade)), green: (getRainbowColor(prog: currentColor)[1] * CGFloat(colorShade)), blue: (getRainbowColor(prog: currentColor)[2] * CGFloat(colorShade)), alpha: alpha)
                        }
                    }
                    let currentColor = 1 + ((rotateProg * 2.0) - 0.0) + (Double(i) / 8.0)
                    
                    if(i%2 == 0) {
                        s.fillColor = UIColor.init(red: CGFloat(1 - colorShade) + (getRainbowColor(prog: currentColor)[0] * CGFloat(colorShade)), green: CGFloat(1 - colorShade) + (getRainbowColor(prog: currentColor)[1] * CGFloat(colorShade)), blue: CGFloat(1 - colorShade) + (getRainbowColor(prog: currentColor)[2] * CGFloat(colorShade)), alpha: CGFloat(finalShadowAlpha0))
                    } else {
                        s.fillColor = UIColor.init(red: (getRainbowColor(prog: currentColor)[0] * CGFloat(colorShade)), green: (getRainbowColor(prog: currentColor)[1] * CGFloat(colorShade)), blue: (getRainbowColor(prog: currentColor)[2] * CGFloat(colorShade)), alpha: CGFloat(finalShadowAlpha0))
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
                                    if(i%2 == 0) {
                                        sp.fillColor = UIColor.init(white: 1.0, alpha: s.fillColor.cgColor.components![3])
                                    } else {
                                        sp.fillColor = UIColor.init(white: 0.0, alpha: s.fillColor.cgColor.components![3])
                                    }
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
                                    //sp.fillColor = s.fillColor
                                    if(i%2 == 0) {
                                        sp.fillColor = UIColor.init(white: 1.0, alpha: s.fillColor.cgColor.components![3])
                                    } else {
                                        sp.fillColor = UIColor.init(white: 0.0, alpha: s.fillColor.cgColor.components![3])
                                    }
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
                                            //sp.fillColor = (s.children[j] as! SKShapeNode).fillColor
                                            if(i%2 == 0) {
                                                sp.fillColor = UIColor.init(white: 1.0, alpha: (s.children[j] as! SKShapeNode).fillColor.cgColor.components![3])
                                            } else {
                                                sp.fillColor = UIColor.init(white: 0.0, alpha: (s.children[j] as! SKShapeNode).fillColor.cgColor.components![3])
                                            }
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
                                            //sp.fillColor = (s.children[j] as! SKShapeNode).fillColor
                                            if(i%2 == 0) {
                                                sp.fillColor = UIColor.init(white: 1.0, alpha: (s.children[j] as! SKShapeNode).fillColor.cgColor.components![3])
                                            } else {
                                                sp.fillColor = UIColor.init(white: 0.0, alpha: (s.children[j] as! SKShapeNode).fillColor.cgColor.components![3])
                                            }
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
                    
                    var color = getRainbowColor(prog: rand())
                    for j in 0...2 {
                        lightingInfo[lightingInfo.count-1].append(Double(color[j]))
                    }
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
                            
                            var coloredAmount = 0.0
                            if(Block.abilityGainAnimationNum == 1) {
                                coloredAmount = 0.35
                            }
                            let color = [lightingInfo[j][3], lightingInfo[j][4], lightingInfo[j][5]];
                            
                            if(angleRange > 0) {
                                let path = UIBezierPath.init()
                                path.move(to: CGPoint.init(x: 0, y: 0))
                                path.addLine(to: CGPoint.init(x: length*cos((angle - angleRange/2) * (3.14159 / 180.0)), y: length*sin((angle - angleRange/2) * (3.14159 / 180.0))))
                                path.addLine(to: CGPoint.init(x: length*cos((angle + angleRange/2) * (3.14159 / 180.0)), y: length*sin((angle + angleRange/2) * (3.14159 / 180.0))))
                                
                                let s = SKShapeNode.init(path: path.cgPath)
                                s.fillColor = UIColor.init(red: (CGFloat(color[0] * coloredAmount)) + CGFloat(1 - coloredAmount), green: (CGFloat(color[1] * coloredAmount)) + CGFloat(1 - coloredAmount), blue: (CGFloat(color[2] * coloredAmount)) + CGFloat(1 - coloredAmount), alpha: 1.0)
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
                        
                        
                        GameState.coloredBlocksUnlocked = true
                        GameState.coloredBlocksVisible = true
                        for row in 0...Board.blocks.count-1 {
                            for col in 0...Board.blocks[0].count-1 {
                                Board.blocks[row][col]!.finishColorReveal()
                            }
                        }
                        EntityManager.reloadAllEntities()
                    } else {
                        
                    }
                    
                    if(!GameState.coloredBlocksUnlocked) {
                        
                        GameState.coloredBlocksUnlocked = true
                        /*GameState.coloredBlocksVisible = true
                        for row in 0...Board.blocks.count-1 {
                            for col in 0...Board.blocks[0].count-1 {
                                if(Board.blocks[row][col]!.type != 9) {
                                    Board.blocks[row][col]!.finishColorReveal()
                                }
                            }
                        }
                        EntityManager.redrawEntities(node: GameState.drawNode, name: "all")*/
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
                //              0                          1                        2                   3                   4             5
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
                            
                            sp.fillColor = UIColor.init(white: 1.0, alpha: 0.1)
                            sp.zPosition = 6
                            
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
    
    private func getRainbowColor(prog: Double) -> [CGFloat] {
        let rainbow: [[CGFloat]] = [[1.0,0.0,0.0],[1.0,0.5,0.0],[1.0,1.0,0.0],[0.0,1.0,0.0],[0.0,0.0,1.0],[1.0,0.0,1.0]]
        
        let progression = prog * 6
        var currentColor = Int(progression)
        var nextColor = Int(progression)+1
        let colorProgression = progression - Double(Int(progression))
        /*if(decreasing) {
            currentColor += 1
            nextColor -= 1
            colorProgression = 1-colorProgression
        }*/
        while(currentColor >= 6) {
            currentColor -= 6
        }
        while(nextColor >= 6) {
            nextColor -= 6
        }
        
        return [(rainbow[currentColor][0] * CGFloat(1-colorProgression))+(rainbow[nextColor][0] * CGFloat(colorProgression)), (rainbow[currentColor][1] * CGFloat(1-colorProgression))+(rainbow[nextColor][1] * CGFloat(colorProgression)), (rainbow[currentColor][2] * CGFloat(1-colorProgression))+(rainbow[nextColor][2] * CGFloat(colorProgression))]
    }
}*/
