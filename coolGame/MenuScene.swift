//
//  GameScene.swift
//  another test game
//
//  Created by Erin Seel on 12/3/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    static let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.width
    static let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.height
    
    var delta = 0.0
    
    var mainView: SKView!
    var controller: MenuViewController!
    var prevTime = 0.0
    
    var loadedElements = false
    
    var inputNode = SKNode()
    var initialLogoScale: CGFloat = 0.0
    var logo: SKSpriteNode!
    var fullTitleNode: SKNode!
    var title: SKLabelNode!
    var titleParticleNode: SKNode!
    var startGame: MenuButton!
    var startEditor: MenuButton!
    var startGamePosition = CGPoint()
    var startEditorPosition = CGPoint()
    var startInstructions: MenuButton!
    
    var logoAlphaMin = 0.3
    var titleParticles: [titleParticle] = []
    var titleCharacters: [SKLabelNode] = []
    
    var titleInverted = false
    let titleInvertTimerMax = 10.0
    var titleInvertTimer = 10.0
    let titleInvertLengthDefault = 0.2
    var titleInvertLength = 0.2
    var titleStartPosition = CGPoint()
    
    let menuAnimationTimerMax = 7.5
    var menuAnimationTimer = 0.0
    var MAlogoTimerMin = 0.1
    var MAlogoTimerMax = 0.5
    var MAbuttonFadeTimerMin = 0.6
    var MAbuttonFadeTimerMax = 0.9
    var MAtitleFadeTimerMin = 0.5
    var MAtitleFadeTimerMax = 0.8
    var MAtitleParticleTimerMin = 0.3
    var MAtitleParticleTimerMax = 0.9
    
    var exitTarget = ""
    let menuExitTimerMax = 7.0
    var menuExitTimer = 0.0
    var MEbuttonFadeTimerMin = 0.0
    var MEbuttonFadeTimerMax = -1.0 //initialized in didMove(to view)
    var MElogoTimerMin = 0.0
    var MElogoTimerMax = 1.0
    var MEtitleMovementTimerMin = 0.1
    var MEtitleMovementTimerMax = 0.73
    var MEtitleGrowTimerMin = 0.4
    var MEtitleGrowTimerMax = 0.8
    var MEtitleFadeTimerMin = 0.85
    var MEinputFadeTimerMin = 0.9
    var MEinputFadeTimerMax = 1.0
    var fadeTitle = false
    
    struct titleParticle {
        var sprite = SKShapeNode()
        var size = CGFloat(0.0)
        
        var movementTimerMin = 0.0
        var movementTimerMax = 0.0
        var endRotation = CGFloat(0)
        
        var curveVector = CGVector(dx: 0, dy: 0)
        var startPosition = CGPoint(x: 0, y: 0)
        var endPosition = CGPoint(x: 0, y: 0)
        
        var shadeTimerShift = 0.0
        var shadeShiftSlope = 0.0
        var shadeShift = 0.0
    }
    
    override func didMove(to view: SKView) {
        mainView = view
        MEbuttonFadeTimerMax = MEbuttonFadeTimerMin + ((MAbuttonFadeTimerMax - MAbuttonFadeTimerMin) * (menuExitTimerMax / menuAnimationTimerMax))
        
        if(!loadedElements) {
            loadedElements = true
            
            inputNode = SKNode.init()
            InputController.inputButtonNode = inputNode
            InputController.initElements()
            inputNode.alpha = 0.0
            view.scene?.addChild(inputNode)
            
            backgroundColor = UIColor.black
            menuAnimationTimer = menuAnimationTimerMax
            
            logo = SKSpriteNode.init(imageNamed: "logo_HD.png")
            initialLogoScale = CGFloat(min(MenuScene.screenWidth, MenuScene.screenHeight) / logo.frame.width)
            logo.xScale = initialLogoScale
            logo.yScale = initialLogoScale
            logo.position = CGPoint(x: 0, y: 0)
            logo.zPosition = -2
            view.scene?.addChild(logo)
            
            let border = Double(GameState.screenHeight / 12.5)
            
            fullTitleNode = SKNode.init()
            title = SKLabelNode.init(text: "SHIFT")
            title.fontName = "Menlo-BoldItalic"
            title.fontSize = CGFloat(92 * Double(GameState.screenWidth / 667.0))
            title.fontColor = UIColor.clear
            titleStartPosition = CGPoint(x: Double(GameState.screenWidth / -2) + (border*1.8) + Double(title.frame.width / 2), y: Double(GameState.screenHeight / 2) - (border*1.2) - Double(title.frame.height / 1))
            fullTitleNode.position = titleStartPosition
            title.alpha = 1.0
            title.zPosition = 2
            var startX = title.frame.width / -2
            let startY = CGFloat(0.0)
            for i in 0...4 {
                let char = SKLabelNode.init(text: ("SHIFT").charAt(i))
                char.fontName = "Menlo-BoldItalic"
                char.fontSize = CGFloat(92 * Double(GameState.screenWidth / 667.0))
                char.fontColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
                
                if(i == 0) {
                    startX += char.frame.width / 2
                }
                char.position = CGPoint(x: startX, y: startY)
                char.alpha = 1.0
                
                startX += char.frame.width
                title.addChild(char)
            }
            fullTitleNode.addChild(title)
            view.scene?.addChild(fullTitleNode)
            
            
            var buttonWidth = Double(GameState.screenHeight / 2.64)
            let buttonHeight = Double(GameState.screenHeight / 5.5)
            var currentButtonIndex = 0
            var yShift = 0.0
            
            currentButtonIndex += 1
            yShift = (Double(currentButtonIndex) - 0.65) * (buttonHeight + border)
            startGame = MenuButton.init(x: Double(GameState.screenWidth / 2.15) - buttonWidth, y: -buttonHeight/2 - yShift, width: buttonWidth, height: buttonHeight, text: "GAME", textColor: UIColor.black, color: UIColor.clear)
            startGamePosition = startGame.label.position
            startGame.label.fontName = "Menlo-BoldItalic"
            view.scene?.addChild(startGame.label)
            
            buttonWidth = Double(GameState.screenHeight / 1.76)
            currentButtonIndex += 1
            yShift = (Double(currentButtonIndex) - 0.65) * (buttonHeight + border)
            startEditor = MenuButton.init(x: Double(GameState.screenWidth / 2.15) - buttonWidth, y: -buttonHeight/2 - yShift, width: buttonWidth, height: buttonHeight, text: "EDITOR", textColor: UIColor.black, color: UIColor.clear)
            startEditorPosition = startEditor.label.position
            startEditor.label.fontName = "Menlo-BoldItalic"
            view.scene?.addChild(startEditor.label)
            
            startGame.update()
            startEditor.update()
            
            
            titleParticleNode = SKNode()
            titleParticleNode.position = CGPoint(x: 0, y: 0)
            fullTitleNode.addChild(titleParticleNode)
            
            let numParticlesNS = 3
            var particleSize = (title.frame.height / CGFloat(numParticlesNS))
            let numParticlesEW = Int(title.frame.width / particleSize)
            particleSize *= 1.3
            for x in 0...numParticlesEW-1 {
                for y in 0...numParticlesNS-1 {
                    for orientation in 0...1 {
                        let center = CGPoint.init(x: title.frame.midX, y: title.frame.midY)
                        let particleWidthRotated = particleSize * CGFloat(sqrt(3.0) / 2.0)
                        var dx = (CGFloat(x) - (CGFloat(numParticlesEW) / 2.0) + 0.3) * particleWidthRotated
                        var dy = (CGFloat(y) - (CGFloat(numParticlesNS) / 2.0) + 0.75) * particleSize
                        if(orientation == 1) {
                            dy -= (particleSize/2)
                            dx += (particleWidthRotated / 3)
                        }
                        if(x%2 == 1) {
                            if(orientation == 1) {
                                dy += particleSize/2
                            } else {
                                dy -= particleSize/2
                            }
                        }
                        var particle = titleParticle()
                        particle.startPosition = CGPoint(x: (GameState.screenWidth / 1.5) + particleSize, y: (GameState.screenHeight / -1.5) - particleSize)
                        particle.endPosition = CGPoint(x: center.x + dx, y: center.y + dy)
                        let curveMod =  CGFloat((rand() * 1.3) - 0.15)
                        particle.curveVector = CGVector(dx: (particle.startPosition.y-particle.endPosition.y) * -0.3 * curveMod, dy: (particle.startPosition.x-particle.endPosition.x) * 0.2 * curveMod)
                        particle.size = particleSize
                        particle.endRotation = CGFloat(3.14159 / 6)
                        if(orientation == 1) {
                            particle.endRotation += CGFloat(3.14159)
                        }
                        particle.endRotation += CGFloat(3.14159 * (Double(Int(rand() * 8) - 4) * 2))
                        let particleDelayPct = max(0, min(1, (Double(x + (numParticlesNS - y)) + (Double(orientation) / 2)) / Double(numParticlesEW * numParticlesNS) * ((rand() * 0.2) + 0.90)))
                        let maxParticleDelay = 0.6
                        particle.movementTimerMin = particleDelayPct * maxParticleDelay
                        particle.movementTimerMax = particle.movementTimerMin + (1 - maxParticleDelay)
                        titleParticles.append(particle)
                        
                        let p = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: -particleSize/2, y: particleSize * -CGFloat(1 * sqrt(3)/6.0)), rotation: 0, size: Double(particleSize)))
                        p.fillColor = UIColor.black
                        p.strokeColor = UIColor.clear
                        p.position = particle.endPosition
                        p.zRotation = particle.endRotation + CGFloat(rand()*0)
                        particle.sprite = p
                        titleParticleNode.addChild(particle.sprite)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputController.touchesBegan(touches, node: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputController.touchesMoved(touches, node: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputController.touchesEnded(touches, node: self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputController.touchesCancelled(touches, node: self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        delta = currentTime - prevTime
        if(prevTime == 0 || delta > 0.3) {
            delta = 0;
        }
        prevTime = currentTime
        
        let titleFlicker = max(0, min(1, pow(rand() - 0.1, 5.0) / pow(0.9, 5))) * 0.5
        if(menuAnimationTimer > 0) {
            menuAnimationTimer -= delta
            if(menuAnimationTimer < 0) {
                menuAnimationTimer = 0
            }
            
            let menuAnimationProg = 1 - (menuAnimationTimer / menuAnimationTimerMax)
            
            var titleFadeProg = max(0, min(1, (menuAnimationProg - MAtitleFadeTimerMin) / (MAtitleFadeTimerMax - MAtitleFadeTimerMin)))
            titleFadeProg = pow(titleFadeProg, 1.0)
            let characterFadeTime = 0.5
            for i in 0...title.children.count-1 {
                let startTimerValue = (1 - Double(characterFadeTime)) * (Double(i) / Double(title.children.count))
                var alpha = CGFloat(max(0, min(1, (titleFadeProg - startTimerValue) / (characterFadeTime))))
                alpha = pow(alpha, 1)
                (title.children[i] as! SKLabelNode).fontColor = UIColor.init(white: CGFloat(0.9-titleFlicker), alpha: alpha)
            }
            
            let buttonFadeProg = max(0, min(1, (menuAnimationProg - MAbuttonFadeTimerMin) / (MAbuttonFadeTimerMax - MAbuttonFadeTimerMin)))
            var buttonProg = 1 - pow(1 - max(0, min(1, (buttonFadeProg - 0.1) / (0.9))), 3)
            startGame.label.position.x = startGamePosition.x + (CGFloat(1 - buttonProg) * (GameState.screenWidth / 2))
            buttonProg = 1 - pow(1 - max(0, min(1, (buttonFadeProg - 0.0) / (0.9))), 3)
            startEditor.label.position.x = startEditorPosition.x + (CGFloat(1 - buttonProg) * (GameState.screenWidth / 2))
            
            var logoProg = max(0, min(1, (menuAnimationProg - MAlogoTimerMin) / (MAlogoTimerMax - MAlogoTimerMin)))
            logoProg = skewProgToEdges(prog: logoProg, power: 3.0)
            
            logo.position = CGPoint(x: logoProg * Double(MenuScene.screenWidth) / -2, y: logoProg * Double(MenuScene.screenHeight) / -2)
            logo.zRotation = CGFloat(-3.14159 * logoProg / 2)
            logo.xScale = initialLogoScale * CGFloat(1 + logoProg)
            logo.yScale = logo.xScale
            logo.alpha = CGFloat(1 - ((1 - logoAlphaMin) * logoProg))
            
            let titleParticleProg = max(0, min(1, (menuAnimationProg - MAtitleParticleTimerMin) / (MAtitleParticleTimerMax - MAtitleParticleTimerMin)))
            for i in 0...titleParticles.count-1 {
                let p = titleParticleNode.children[i]
                let p2 = titleParticles[i]
                var particleMovementProg = max(0, min(1, (titleParticleProg - p2.movementTimerMin) / (p2.movementTimerMax - p2.movementTimerMin)))
                let particleVectorProg = 1 - pow(((abs(particleMovementProg - 0.5)) * 2), 2)
                particleMovementProg = skewProgToEdges(prog: particleMovementProg, power: 2.0)
                p.position = CGPoint(x: (p2.startPosition.x * CGFloat(1 - particleMovementProg)) + (p2.endPosition.x * CGFloat(particleMovementProg)) + (p2.curveVector.dx * CGFloat(particleVectorProg)), y: (p2.startPosition.y * CGFloat(1 - particleMovementProg)) + (p2.endPosition.y * CGFloat(particleMovementProg)) + (p2.curveVector.dy * CGFloat(particleVectorProg)))
                p.zRotation = p2.endRotation * CGFloat(particleMovementProg)
            }
            /*
            for i in 0...titleParticleNode.children.count-1 {
                titleParticles[i].shadeShiftSlope = max(-0.03, min(0.03, titleParticles[i].shadeShiftSlope + ((rand() * 0.008) -  0.004)))
                titleParticles[i].shadeShift = titleParticles[i].shadeShift + titleParticles[i].shadeShiftSlope
                if(titleParticles[i].shadeShift >= 1) {
                    titleParticles[i].shadeShift = 1
                    titleParticles[i].shadeShiftSlope = 0
                } else if(titleParticles[i].shadeShift <= 0) {
                    titleParticles[i].shadeShift = 0
                    titleParticles[i].shadeShiftSlope = 0
                }
                (titleParticleNode.children[i] as! SKShapeNode).fillColor = UIColor.init(white: (CGFloat(titleParticles[i].shadeShift) * 0.2) + 0.15, alpha: 1.0)
            }*/
        } else if(menuExitTimer > 0) {
            menuExitTimer -= delta
            if(menuExitTimer <= 0) {
                menuExitTimer = 0
                controller.goToScene(exitTarget)
            }
            
            let menuExitProg = 1 - (menuExitTimer / menuExitTimerMax)
            
            let buttonFadeProg = max(0, min(1, (menuExitProg - MEbuttonFadeTimerMin) / (MEbuttonFadeTimerMax - MEbuttonFadeTimerMin)))
            var buttonProg = pow(max(0, min(1, (buttonFadeProg - 0.0) / (0.9))), 3)
            startGame.label.position.x = startGamePosition.x + (CGFloat(buttonProg) * (GameState.screenWidth / 2))
            buttonProg = pow(max(0, min(1, (buttonFadeProg - 0.1) / (0.9))), 3)
            startEditor.label.position.x = startEditorPosition.x + (CGFloat(buttonProg) * (GameState.screenWidth / 2))
            
            
            var logoProg = max(0, min(1, (menuExitProg - MElogoTimerMin) / (MElogoTimerMax - MElogoTimerMin)))
            logoProg = pow(logoProg, 2)
            
            let logoPositionProg = max(0, min(1, logoProg * 1.4))
            logo.position = CGPoint(x: (1 - logoPositionProg) * Double(MenuScene.screenWidth) / -2, y: (1 - logoPositionProg) * Double(MenuScene.screenHeight) / -2)
            logo.zRotation = CGFloat(3.14159 * ((pow(logoProg, 3) + logoProg) / 2) * 8) - CGFloat(3.14159 / 2)
            logo.xScale = initialLogoScale * CGFloat(1 + (pow((logoProg - 0.08) / 0.92, 6) * 16))
            logo.yScale = logo.xScale
            logo.alpha = CGFloat(logoAlphaMin * (1 - logoProg)) + (Board.gray * CGFloat(logoProg))
            
            
            var titleMovementProg = max(0, min(1, (menuExitProg - MEtitleMovementTimerMin) / (MEtitleMovementTimerMax - MEtitleMovementTimerMin)))
            titleMovementProg = skewProgToEdges(prog: titleMovementProg, power: 3.0)
            
            fullTitleNode.position = CGPoint(x: (titleStartPosition.x * CGFloat(1 - titleMovementProg)), y: (titleStartPosition.y * CGFloat(1 - titleMovementProg)) + ((title.frame.height / 2) * CGFloat(titleMovementProg)))
            
            
            var titleGrowProg = max(0, min(1, (menuExitProg - MEtitleGrowTimerMin) / (MEtitleGrowTimerMax - MEtitleGrowTimerMin)))
            titleGrowProg = skewProgToEdges(prog: titleGrowProg, power: 2.0)
            
            fullTitleNode.xScale = CGFloat(1 + (titleGrowProg * 0.3))
            fullTitleNode.yScale = fullTitleNode.xScale
            
            
            titleInvertLength = (titleInvertLengthDefault / ((menuExitProg * 7) + 1)) * 1
            if(fadeTitle == false && !titleInverted && titleInvertTimer > titleInvertTimerMax * titleInvertLength && menuExitProg > MEtitleFadeTimerMin) {
                fadeTitle = true
            }
            
            
            let inputFadeProg = max(0, min(1, (menuExitProg - MEinputFadeTimerMin) / (MEinputFadeTimerMax - MEinputFadeTimerMin)))
            
            inputNode.alpha = CGFloat(pow(inputFadeProg, 2))
        }
        
        if(menuAnimationTimer == 0) {
            if(titleInvertTimer > 0) {
                titleInvertTimer -= delta
            }
            if(titleInvertTimer <= 0) {
                titleInverted = !titleInverted
                if(fadeTitle) {
                    titleInvertTimer = 999
                    fullTitleNode.alpha = 0.0
                } else if(menuExitTimer != 0) {
                    titleInvertTimer = titleInvertTimerMax * titleInvertLength
                } else {
                    titleInvertTimer = titleInvertTimerMax
                }
            }
        }
        
        var inversionProg = 1 - (titleInvertTimer / titleInvertTimerMax)
        inversionProg = max(0, min(1, (inversionProg - (1 - titleInvertLength)) / titleInvertLength))
        
        if(!fadeTitle) {
            let characterFadeTime = 0.4
            for i in 0...title.children.count-1 {
                if(menuAnimationTimer == 0) {
                    let startTimerValue = (1 - Double(characterFadeTime)) * (Double(i) / Double(title.children.count))
                    var colorChange = (max(0, min(1, (inversionProg - startTimerValue) / (characterFadeTime))))
                    colorChange = pow(colorChange, 1)
                    var gray = ((0.9 - titleFlicker) * (1 - colorChange))
                    gray += ((0.1 + titleFlicker) * (colorChange))
                    
                    if(!titleInverted) {
                        (title.children[i] as! SKLabelNode).fontColor = UIColor.init(white: CGFloat(gray), alpha: 1.0)
                    } else {
                        (title.children[i] as! SKLabelNode).fontColor = UIColor.init(white: CGFloat(1 - gray), alpha: 1.0)
                    }
                }
            }
            
            let triangleFadeTime = 0.4
            for i in 0...titleParticleNode.children.count-1 {
                titleParticles[i].shadeShiftSlope = max(-0.03, min(0.03, titleParticles[i].shadeShiftSlope + ((rand() * 0.008) -  0.004)))
                titleParticles[i].shadeShift = titleParticles[i].shadeShift + titleParticles[i].shadeShiftSlope
                if(titleParticles[i].shadeShift >= 1) {
                    titleParticles[i].shadeShift = 1
                    titleParticles[i].shadeShiftSlope = 0
                } else if(titleParticles[i].shadeShift <= 0) {
                    titleParticles[i].shadeShift = 0
                    titleParticles[i].shadeShiftSlope = 0
                }
                
                let startTimerValue = (1 - Double(triangleFadeTime)) * (Double(titleParticles[i].endPosition.x - titleParticles[0].endPosition.x) / Double(titleParticles[titleParticles.count-1].endPosition.x - titleParticles[0].endPosition.x))
                var colorChange = (max(0, min(1, (inversionProg - startTimerValue) / (triangleFadeTime))))
                colorChange = pow(colorChange, 1)
                var gray = (((titleParticles[i].shadeShift * 0.2) + 0.15) * (1 - colorChange))
                gray += (((1 - (titleParticles[i].shadeShift * 0.2)) - 0.15) * (colorChange))
                
                if(!titleInverted) {
                    (titleParticleNode.children[i] as! SKShapeNode).fillColor = UIColor.init(white: CGFloat(gray), alpha: 1.0)
                } else {
                    (titleParticleNode.children[i] as! SKShapeNode).fillColor = UIColor.init(white: CGFloat(1 - gray), alpha: 1.0)
                }
            }
        } else {
            let characterFadeTime = 0.4
            for i in 0...title.children.count-1 {
                if(menuAnimationTimer == 0) {
                    let startTimerValue = (1 - Double(characterFadeTime)) * (Double(i) / Double(title.children.count))
                    var colorChange = (max(0, min(1, (inversionProg - startTimerValue) / (characterFadeTime))))
                    colorChange = pow(colorChange, 1)
                    let gray = (0.9 - titleFlicker)
                    
                    if(!titleInverted) {
                        (title.children[i] as! SKLabelNode).fontColor = UIColor.init(white: CGFloat(gray), alpha: CGFloat(1-colorChange))
                    } else {
                        //(title.children[i] as! SKLabelNode).fontColor = UIColor.init(white: CGFloat(1 - gray), alpha: 1.0)
                    }
                }
            }
            
            let triangleFadeTime = 0.4
            for i in 0...titleParticleNode.children.count-1 {
                titleParticles[i].shadeShiftSlope = max(-0.03, min(0.03, titleParticles[i].shadeShiftSlope + ((rand() * 0.008) -  0.004)))
                titleParticles[i].shadeShift = titleParticles[i].shadeShift + titleParticles[i].shadeShiftSlope
                if(titleParticles[i].shadeShift >= 1) {
                    titleParticles[i].shadeShift = 1
                    titleParticles[i].shadeShiftSlope = 0
                } else if(titleParticles[i].shadeShift <= 0) {
                    titleParticles[i].shadeShift = 0
                    titleParticles[i].shadeShiftSlope = 0
                }
                
                let startTimerValue = (1 - Double(triangleFadeTime)) * (Double(titleParticles[i].endPosition.x - titleParticles[0].endPosition.x) / Double(titleParticles[titleParticles.count-1].endPosition.x - titleParticles[0].endPosition.x))
                var colorChange = (max(0, min(1, (inversionProg - startTimerValue) / (triangleFadeTime))))
                colorChange = pow(colorChange, 1)
                let gray = ((titleParticles[i].shadeShift * 0.2) + 0.15)
                
                if(!titleInverted) {
                    (titleParticleNode.children[i] as! SKShapeNode).fillColor = UIColor.init(white: CGFloat(gray), alpha: CGFloat(1-colorChange))
                } else {
                    //(titleParticleNode.children[i] as! SKShapeNode).fillColor = UIColor.init(white: CGFloat(1 - gray), alpha: 1.0)
                }
            }
        }
        
        startGame.update()
        startEditor.update()
        
        if(menuExitTimer == 0 && menuAnimationTimer == 0) {
            if(startGame.isPressed) {
                exitTarget = "game"
                initialLogoScale = logo.xScale
                titleInvertTimer = titleInvertTimerMax * titleInvertLength * 1
                menuExitTimer = menuExitTimerMax
            }
            if(startEditor.isPressed) {
                exitTarget = "editor"
                initialLogoScale = logo.xScale
                titleInvertTimer = titleInvertTimerMax * titleInvertLength * 1
                menuExitTimer = menuExitTimerMax
            }
        }
        //if(startInstructions.isPressed) {
            //controller.goToScene("testing")
        //}*/
    }
    
    private func skewProgToEdges(prog: Double, power: Double) -> Double {
        let secondHalf = prog > 0.5
        var p = prog
        p -= 0.5
        p *= 2
        p = abs(p)
        p = pow(1 - p, power)
        p = 1 - p
        p /= 2
        if(secondHalf) {
            p *= -1
        }
        p += 0.5
        p = 1 - p
        return p
    }
    
    private func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
