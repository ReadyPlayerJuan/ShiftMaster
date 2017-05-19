//
//  GameState.swift
//  Drawing Test
//
//  Created by Erin Seel on 11/26/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class GameState {
    static let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.width
    static let screenWidth = UIScreen.main.bounds.width
    
    static var gamescene: GameScene!
    static var editorscene: EditorScene!
    
    static var superNode: SKShapeNode!
    static var drawNode: SKShapeNode!
    static var rotateNode: SKShapeNode!
    
    static var prevState = "in menu"
    static var prevPlayerState =  "free"
    static var state = "in menu"
    static var playerState = "free"
    static var inEditor = false
    static var currentlyEditing = false
    
    static var currentDelta = 0.0
    static var ignoreDelta = true
    
    static var firstFrame = false
    static var lastFrame = false
    
    static var enteringStage = true
    static var stageTransitionTimer = 0.0
    static var stageTransitionTimerMaxDefaults = [2.0, 4.0]
    static var stageTransitionTimerMax = stageTransitionTimerMaxDefaults[0]
    static var stageTransitionAngle = 0.0
    static var stageTransitionType = 0
    static var exitTarget = 0
    
    static var rotateDirection = "right"
    static var hingeDirection = "right"
    static var rotateTimer = 0.0
    static let rotateTimerMax = 1.0
    
    static var endingStage = false
    static var colorChangeTimer = 0.0
    static let colorChangeTimerMax = 1.0
    
    static var infoScreenNum = 0
    static var infoScreenState = ""
    static var infoScreenTimer = 0.0
    static let infoScreenFadeDuration = 0.5
    static let maxInfoScreenAlpha = 1.0
    static var infoImage: SKSpriteNode!
    
    static var deathTimer = 0.0
    static let deathTimerMax = 4.0
    static var numRotations = 0
    static var prevDirection = 0
    
    static var inverted = false
    static var inversionTimer = 0.0
    static let inversionTimerMax = 1.5
    static var inversionBorderSprite: SKNode!
    static var inversionParticleCounter = 0.0
    static let inversionParticlesPerSecond = 90.0
    static var inversionColorIndexes = [Int]()
    
    static var colorRevealTimer = 0.0
    static let colorRevealTimerMax = 2.0
    static var coloredBlocksUnlocked = false
    static var coloredBlocksVisible = false
    
    static var gainAbilityTimer = 0.0
    static let gainAbilityTimerMax = 35.0//15.0
    
    //static private let GAshiftFactor = 0.84
    static let GArotateTimerMin = 0.0
    static let GArotateTimerMax = 0.672
    static let GAshadeChangeTimerMin = 0.546
    static let GAshadeChangeTimerMax = 0.672
    static let GAscreenFloodTimerMin = 0.672
    static let GAscreenFloodTimerMax = 0.722
    static let GAscreenFloodTimerMin2 = 0.764
    static let GAscreenFloodTimerMax2 = 0.798
    static let GAspinningLightTimerMin = 0.0
    static let GAspinningLightTimerMax = GAscreenFloodTimerMax
    static let GAexplosionTimerMin = 0.798
    static let GAexplosionTimerMax = 0.97
    static let GAscreenRotateTimerMin = 0.067
    static let GAscreenRotateTimerMax = 0.672
    static let GAcolorRevealTimerMin = 0.85
    static let GAcolorRevealTimerMax = 0.98
    
     /*static let GArotateTimerMin = 0.0
     static let GArotateTimerMax = 0.2
     static let GAshadeChangeTimerMin = 0.0
     static let GAshadeChangeTimerMax = 0.2
     static let GAscreenFloodTimerMin = 0.672
     static let GAscreenFloodTimerMax = 0.722
     static let GAscreenFloodTimerMin2 = 0.764
     static let GAscreenFloodTimerMax2 = 0.798
     static let GAspinningLightTimerMin = 0.0
     static let GAspinningLightTimerMax = 0.2
     static let GAexplosionTimerMin = 0.798
     static let GAexplosionTimerMax = 0.97
     static let GAscreenRotateTimerMin = 0.067
     static let GAscreenRotateTimerMax = 0.672
     static let GAcolorRevealTimerMin = 0.85
     static let GAcolorRevealTimerMax = 0.98*/
    
    static let maxMoveSpeed = 3.8
    static let slideLength = 0.1
    static let accelerationBonus = 3.0
    static let jumpHeight = 2.25
    static let jumpLength = 0.40
    static let gravity = jumpHeight / (pow(jumpLength, 2))
    
    static var testing = false
    
    static var globalRand = 0.0
    static var time = 0.0
    
    class func initEntities() {
        EntityManager.entities = []
        
        let p = Player.init()
        EntityManager.addEntity(entity: p)
        
        for row in 0 ... Board.blocks.count-1 {
            for col in 0 ... Board.blocks[0].count-1 {
                EntityManager.addEntity(entity: Board.blocks[row][col]!)
            }
        }
        
        if(Board.otherEntities.count != 0) {
            for e in Board.otherEntities {
                EntityManager.addEntity(entity: e)
            }
        }
        (EntityManager.getPlayer()! as! Player).reset()
        EntityManager.loadLightSources()
        
        EntityManager.sortEntities()
        EntityManager.redrawEntities(node: drawNode, name: "all")
    }
    
    class func update(delta: TimeInterval) {
        currentDelta = delta
        if(ignoreDelta || delta > 1) {
            ignoreDelta = false
            currentDelta = 0
        }
        
        
        time += currentDelta
        globalRand = rand()
        
        prevState = state
        prevPlayerState = playerState
        
        InputController.update()
        
        if(inEditor) {
            EditorManager.update(delta: currentDelta)
        }
        
        if(state == "in game") {
            if(playerState == "changing color") {
                firstFrame = false
                lastFrame = false
                
                if(colorChangeTimer == colorChangeTimerMax) {
                    actionFirstFrame()
                }
                
                colorChangeTimer -= currentDelta
                
                if(colorChangeTimer <= 0) {
                    colorChangeTimer = 0
                    actionLastFrame()
                }
            }
            
            if(!currentlyEditing) {
                EntityManager.updateEntities(delta: currentDelta)
                Camera.centerOnPlayer()
            } else {
                Camera.centerOnEditorCamera()
            }
        } else if(state == "in menu") {
            //handled by other scenes
        } else if(state == "in editor") {
            Camera.centerOnEditorCamera()
        } else if(state == "stage transition") {
            firstFrame = false
            lastFrame = false
            
            stageTransitionTimer -= currentDelta
            if(!currentlyEditing) {
                switch(stageTransitionType) {
                case 0:
                    Camera.centerOnStageTransitionVector()
                    break
                case 1:
                    Camera.centerOnPlayer()
                    break
                default:
                    break
                }
            }
            
            if(stageTransitionTimer <= 0) {
                inverted = false
                //coloredBlocksVisible = false
                stageTransitionTimer = 0
                
                if(!enteringStage) {
                    enteringStage = true
                    stageTransitionType = 0
                    stageTransitionTimerMax = stageTransitionTimerMaxDefaults[0]
                    stageTransitionTimer = stageTransitionTimerMax
                    Board.nextStage()
                    initEntities()
                    
                    if(Board.currentStage!.playShowColorAnimation) {
                        coloredBlocksVisible = false
                    }
                    
                    
                    Camera.centerOnStageTransitionVector()
                    
                    if(inEditor) {
                        EditorManager.exitStageButton.sprite[0].alpha = 0.0
                        GameState.gameAction(type: "begin editor")
                    }
                } else {
                    if(currentlyEditing) {
                        GameState.actionFirstFrame()
                    } else {
                        state = "in game"
                        playerState = "free"
                        Camera.centerOnPlayer()
                        EntityManager.checkForCollision()
                        infoScreenNum = 0
                        
                        if(coloredBlocksUnlocked && Board.currentStage!.playShowColorAnimation) {
                            gameAction(type: "reveal colors")
                        }
                        if((Board.currentStage?.infoScreens.count)! > 0) {
                            gameAction(type: "info")
                        }
                    }
                }
            }
            
            EntityManager.updateEntitySprites()
        } else if(state == "rotating") {
            firstFrame = false
            lastFrame = false
            
            if(rotateTimer == rotateTimerMax) {
                actionFirstFrame()
            }
            
            rotateTimer -= currentDelta
            
            if(rotateTimer <= rotateTimerMax / 4 && playerState == "paused" && !currentlyEditing) {
                playerState = "free"
            }
            
            if(rotateTimer <= 0) {
                rotateTimer = 0
                actionLastFrame()
            }
            
            EntityManager.updateEntities(delta: currentDelta)
            if(!currentlyEditing) {
                Camera.centerOnPlayer()
            } else {
                Camera.centerOnEditorCamera()
            }
            rotateNode.zRotation = CGFloat(getRotationValue())
        } else if(state == "resetting stage") {
            firstFrame = false
            lastFrame = false
            
            if(deathTimer == deathTimerMax) {
                actionFirstFrame()
            }
            
            deathTimer -= currentDelta
            
            if(deathTimer <= 0) {
                deathTimer = 0
                actionLastFrame()
            }
            
            EntityManager.updateEntities(delta: currentDelta)
            Camera.centerOnDeathVector()
            rotateNode.zRotation = CGFloat(getDeathRotation())
        } else if(state == "info screen") {
            if(infoScreenState == "fade in") {
                infoScreenTimer += delta
                if(infoScreenTimer >= infoScreenFadeDuration) {
                    infoScreenTimer = infoScreenFadeDuration
                    infoScreenState = "visible"
                }
                infoImage.alpha = CGFloat(maxInfoScreenAlpha * (infoScreenTimer / infoScreenFadeDuration))
            } else if(infoScreenState == "visible") {
                infoImage.alpha = CGFloat(maxInfoScreenAlpha)
                if(InputController.currentTouches.count > 0) {
                    infoScreenState = "fade out"
                }
            } else if(infoScreenState == "fade out") {
                infoScreenTimer -= delta
                infoImage.alpha = CGFloat(maxInfoScreenAlpha * (infoScreenTimer / infoScreenFadeDuration))
                if(infoScreenTimer <= 0) {
                    infoScreenTimer = 0
                    state = "in game"
                    playerState = "free"
                    infoImage.removeFromParent()
                }
            }
        } else if(state == "inverting") {
            firstFrame = false
            lastFrame = false
            
            if(inversionTimer == inversionTimerMax) {
                actionFirstFrame()
            }
            
            inversionTimer -= currentDelta
            
            if(inversionTimer <= 0) {
                inversionTimer = 0
                actionLastFrame()
            }
            
            
            inversionParticleCounter += delta * inversionParticlesPerSecond
            let xPos = getInversionLinePosition()
            while(inversionParticleCounter >= 0) {
                inversionParticleCounter -= 1
                
                let yPos = ((1 - (rand()*2))*(Double(screenHeight/2) / Board.blockSize)) - (EntityManager.getPlayer()!.y - 0.5)
                
                var colorIndex: Int!
                if(inversionColorIndexes.count == 0) {
                    colorIndex = Int(rand() * 6)
                } else {
                    colorIndex = inversionColorIndexes[Int(rand() * Double(inversionColorIndexes.count))]
                }
                let colorI = ColorTheme.colors[Board.colorTheme][colorIndex]
                var color: UIColor!
                if(inverted) {
                    color = UIColor.init(red: CGFloat(colorI[0])/255.0, green: CGFloat(colorI[1])/255.0, blue: CGFloat(colorI[2])/255.0, alpha: 1.0)
                } else {
                    color = UIColor.init(red: 1-(CGFloat(colorI[0])/255.0), green: 1-(CGFloat(colorI[1])/255.0), blue: 1-(CGFloat(colorI[2])/255.0), alpha: 1.0)
                }
                
                EntityManager.addParticle(particle: Particle.init(x: xPos-0.1, y: -yPos, angle: 175 + (rand() * 10), distance: -1.1, startAngle: rand() * 0, endAngle: (2*(Double(Int(rand()*2))-0.5)) * ((rand() * 360) + 90), shape: 0, color: color, lifeTime: 0.5, deathType: 1))
            }
            
            EntityManager.updateEntities(delta: currentDelta)
            
            inversionBorderSprite.position = CGPoint.init(x: (getInversionLinePosition())*Board.blockSize, y: -(EntityManager.getPlayer()!.y - 0.5)*Board.blockSize)
            Camera.centerOnPlayer()
        } else if(state == "revealing colors") {
            firstFrame = false
            lastFrame = false
            
            if(colorRevealTimer == colorRevealTimerMax) {
                actionFirstFrame()
            }
            
            colorRevealTimer -= currentDelta
            
            if(colorRevealTimer <= 0) {
                colorRevealTimer = 0
                actionLastFrame()
            }
            
            EntityManager.updateEntities(delta: currentDelta)
            
            Camera.centerOnPlayer()
        } else if(state == "gaining ability") {
            firstFrame = false
            lastFrame = false
            
            if(gainAbilityTimer == gainAbilityTimerMax) {
                actionFirstFrame()
            }
            
            gainAbilityTimer -= currentDelta
            
            if(gainAbilityTimer <= 0) {
                gainAbilityTimer = 0
                actionLastFrame()
            }
            
            EntityManager.updateEntities(delta: currentDelta)
            Camera.centerOnPlayer()
            
            rotateNode.zRotation = CGFloat(getGainAbilityRotation())
        }
        
        Camera.update(delta: delta)
        InputController.prevTouches = InputController.currentTouches
    }
    
    class func gameAction(type: String) {
        if(type == "rotate") {
            state = "rotating"
        } else if(type == "kill player") {
            state = "resetting stage"
        } else if(type == "change color") {
            playerState = "changing color"
            endingStage = false
        } else if(type == "end stage") {
            playerState = "changing color"
            endingStage = true
            stageTransitionType = 0
        } else if(type == "begin editor") {
            GameState.currentlyEditing = true
            GameState.inEditor = true
            state = "stage transition"
            stageTransitionTimer = 0
            enteringStage = true
            Board.blockSize = Board.defaultBlockSize / 2
        } else if(type == "info") {
            state = "info screen"
            infoScreenState = "fade in"
            let texture = SKTexture.init(image: UIImage.init(named: "tutorial\((Board.currentStage?.infoScreens[0])!).png")!)
            infoImage = SKSpriteNode.init(texture: texture)
            
            if #available(iOS 10.0, *) {
                infoImage.scale(to: CGSize.init(width: GameState.screenWidth, height: GameState.screenHeight))
            } else {
                infoImage.xScale = (GameState.screenWidth / infoImage.size.width)
                infoImage.yScale = (GameState.screenHeight / infoImage.size.height)
            }
            
            infoImage.alpha = 0.0
            infoImage.zPosition = 200
            superNode.addChild(infoImage)
        } else if(type == "invert") {
            state = "inverting"
            playerState = "paused"
            inversionTimer = inversionTimerMax
        } else if(type == "reveal colors") {
            state = "revealing colors"
            playerState = "paused"
            colorRevealTimer = colorRevealTimerMax
        } else if(type == "gain ability") {
            playerState = "paused"
            state = "gaining ability"
            Block.abilityGainAnimationNum = Player.maxAbilities
        }
        
        if(state == "rotating" && playerState != "changing color") {
            playerState = "paused"
            rotateTimer = rotateTimerMax
            rotateDirection = hingeDirection
        } else if(state == "resetting stage") {
            deathTimer = deathTimerMax
            
            GameState.prevDirection = Board.direction
            switch(Board.direction) {
            case 0:
                numRotations = 0; break
            case 1:
                numRotations = 1
                rotateDirection = "left"; break
            case 2:
                numRotations = 2
                rotateDirection = "left"; break
            case 3:
                numRotations = 1
                rotateDirection = "right"; break
            default:
                numRotations = 0; break
            }
        } else if(playerState == "changing color") {
            colorChangeTimer = colorChangeTimerMax
        } else if(state == "stage transition" && currentlyEditing) {
            EditorManager.initElements()
        } else if(state == "gaining ability") {
            gainAbilityTimer = gainAbilityTimerMax
        }
    }
    
    class func actionFirstFrame() {
        firstFrame = true
        
        if(state == "rotating") {
            Board.rotate()
            //Board.orderOtherEntities()
            Camera.centerOnPlayer()
            GameState.rotateNode.zRotation = CGFloat(GameState.getRotationValue())
            
            if(currentlyEditing) {
                let p = Board.rotatePoint(CGPoint(x: EditorManager.camera.y, y: EditorManager.camera.x), clockwise: rotateDirection == "left")
                EditorManager.camera = CGPoint(x: p.y, y: p.x)
            }
            
            EntityManager.loadLightSources()
        } else if(state == "resetting stage") {
            playerState = "respawning"
            if(numRotations > 0) {
                for _ in 0...numRotations-1 {
                    Board.rotate()
                }
            }
            for e in Board.otherEntities {
                if(e.name == "moving block") {
                    (e as! MovingBlock).beginStageReset()
                }
            }
            
            (EntityManager.getPlayer() as! Player).loadDeathEffect(delta: currentDelta)
            Camera.centerOnPlayer()
        } else if(playerState == "changing color") {
            (EntityManager.getPlayer() as! Player).loadColorChangeEffect()
        } else if(state == "stage transition" && currentlyEditing) {
            state = "in game"
            playerState = "free"
            Board.nextStage()
            initEntities()
            EditorManager.initElements()
            
            EditorManager.camera = CGPoint(x: Double(Board.blocks[0].count-1)/2.0, y: Double(Board.blocks.count-1)/2.0)
            Camera.centerOnEditorCamera()
        } else if(state == "inverting") {
            inversionBorderSprite = SKNode.init()
            
            let width = Board.blockSize / 1.7
            let numShades = 15
            
            let a = SKShapeNode.init(rect: CGRect.init(x: -((width/Double(numShades))/4), y: -Double(screenHeight/2), width: ((width/Double(numShades))/2), height: Double(screenHeight)))
            a.zPosition = 150
            a.strokeColor = UIColor.clear
            
            for i in (-numShades)...(numShades) {
                a.position = CGPoint.init(x: (((width/Double(numShades))/2) * Double(i)), y: 0)
                let alpha: CGFloat = 1-CGFloat(pow(Double(abs(i)) / Double(numShades), 1.3))
                //if(inverted) {
                    a.fillColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: alpha)
                //} else {
                    //a.fillColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: alpha)
                //}
                
                inversionBorderSprite.addChild(a.copy() as! SKShapeNode)
            }
            
            inversionBorderSprite.position = CGPoint.init(x: -9999, y: 0)
            drawNode.addChild(inversionBorderSprite)
            
            
            inversionColorIndexes = [Int]()
            for r in 0...Board.blocks.count-1 {
                for c in 0...Board.blocks[0].count-1 {
                    if(Board.blocks[r][c]!.colorIndex != -1) {
                        inversionColorIndexes.append(Board.blocks[r][c]!.colorIndex)
                    }
                }
            }
        } else if(state == "revealing colors") {
            
        } else if(state == "gaining ability") {
            Camera.shake(forTime: gainAbilityTimerMax * GAscreenFloodTimerMax, withIntensity: 0.5, dropoff: false)
        }
    }
    
    class func actionLastFrame() {
        lastFrame = true
        
        if(state == "rotating") {
            state = "in game"
            rotateNode.zRotation = 0.0
            
            if(inEditor && currentlyEditing) {
                state = "in editor"
                EditorManager.rotating = false
            }
        } else if(state == "resetting stage") {
            state = "in game"
            playerState = "free"
            (EntityManager.getPlayer()! as! Player).reset()
            EntityManager.redrawEntities(node: GameState.drawNode, name: "all")
            drawNode.position = CGPoint(x: -((EntityManager.getPlayer()!.x + 0.5) * Double(Board.blockSize)), y: ((EntityManager.getPlayer()!.y - 0.5) * Double(Board.blockSize)))
            
            if(inverted) {
                EntityManager.getPlayer()?.move()
                gameAction(type: "invert")
            }
        } else if(playerState == "changing color") {
            if(!endingStage) {
                (EntityManager.getPlayer() as! Player).finishedChangingColor()
                playerState = "free"
            } else {
                (EntityManager.getPlayer() as! Player).finishedChangingColor()
                beginStageTransition()
            }
        } else if(state == "inverting") {
            inversionBorderSprite.removeFromParent()
            
            inverted = !inverted
            playerState = "free"
            state = "in game"
            if(currentlyEditing) {
                state = "in editor"
            }
            
            for row in 0...Board.blocks.count-1 {
                for col in 0...Board.blocks[0].count-1 {
                    Board.blocks[row][col]!.finishInversion()
                }
            }
            EntityManager.reloadAllEntities()
        } else if(state == "revealing colors") {
            coloredBlocksVisible = true
            playerState = "free"
            state = "in game"
            if(currentlyEditing) {
                state = "in editor"
            }
            
            for row in 0...Board.blocks.count-1 {
                for col in 0...Board.blocks[0].count-1 {
                    Board.blocks[row][col]!.finishColorReveal()
                }
            }
            EntityManager.reloadAllEntities()
        } else if(state == "gaining ability") {
            if(Block.abilityGainAnimationNum == 1) {
                coloredBlocksUnlocked = true
                coloredBlocksVisible = true
            }
            state = "in game"
            playerState = "free"
            
            for r in 0...Board.blocks.count-1 {
                for c in 0...Board.blocks[0].count-1 {
                    if(Board.blocks[r][c]?.type == 9) {
                        Board.blocks[r][c]!.gainedAbility = true
                        Board.blocks[r][c]!.sprite.removeFromParent()
                        Board.blocks[r][c]!.loadSprite()
                    }
                }
            }
            EntityManager.redrawEntities(node: drawNode, name: "all")
            
            if(Player.maxAbilities < Player.allAbilities.count) {
                Player.currentAbilities.append(Player.allAbilities[Player.maxAbilities])
                Player.maxAbilities += 1
            }
        }
    }
    
    class func beginGame() {
        inverted = false
        enteringStage = true
        
        stageTransitionType = 0
        state = "stage transition"
        playerState = "free"
        stageTransitionTimerMax = stageTransitionTimerMaxDefaults[stageTransitionType]
        stageTransitionTimer = stageTransitionTimerMax
        
        Board.reset()
        Board.nextStage()
        initEntities()
    }
    
    class func beginStageTransition() {
        stageTransitionType = Board.currentStage!.stageTransitionType
        if(stageTransitionType == 1) {
            for r in 0...Board.blocks.count-1 {
                for c in 0...Board.blocks[0].count-1 {
                    Board.blocks[r][c]!.beginStageBreakaway()
                }
            }
        }
        
        state = "stage transition"
        playerState = "paused"
        
        stageTransitionTimerMax = stageTransitionTimerMaxDefaults[stageTransitionType]
        stageTransitionTimer = stageTransitionTimerMax
        
        enteringStage = false
        stageTransitionAngle = rand()*(2*3.14159)
    }
    
    class func heightAt(time: Double) -> Double {
        return (GameState.gravity * (time * time)) + GameState.jumpHeight
    }
    
    class func getStageTransitionVector() -> CGVector {
        var vector = CGVector(dx: 0, dy: 0)
        vector.dx += 0
        
        let distance = 1600.0*Double(Board.blockSize)
        
        let n = 4.5
        if(!enteringStage) {
            vector.dx = CGFloat(distance*cos(stageTransitionAngle)*pow(1.0-(stageTransitionTimer/stageTransitionTimerMax), n))
            vector.dy = CGFloat(distance*sin(stageTransitionAngle)*pow(1.0-(stageTransitionTimer/stageTransitionTimerMax), n))
        } else {
            vector.dx = CGFloat(-distance*cos(stageTransitionAngle)*pow(0.0+(stageTransitionTimer/stageTransitionTimerMax), n))
            vector.dy = CGFloat(-distance*sin(stageTransitionAngle)*pow(0.0+(stageTransitionTimer/stageTransitionTimerMax), n))
        }
        
        return vector
    }
    
    class func getInversionLinePosition() -> Double {
        let minX = (EntityManager.getPlayer()!.x) - (Double(screenWidth / 2) / Board.blockSize) - 1
        return minX + (((Double(screenWidth) / Board.blockSize) + 2) * (1-(inversionTimer / inversionTimerMax)))
    }
    
    class func getPrevInversionLinePosition() -> Double {
        let minX = (EntityManager.getPlayer()!.x) - (Double(screenWidth / 2) / Board.blockSize) - 1
        return minX + (((Double(screenWidth) / Board.blockSize) + 2) * (1-(max(0.0, (inversionTimer+currentDelta)) / inversionTimerMax)))
    }
    
    class func getColorRevealLinePosition() -> Double {
        let minX = (EntityManager.getPlayer()!.x) - (Double(screenWidth / 2) / Board.blockSize) - 1
        return minX + (((Double(screenWidth) / Board.blockSize) + 2) * (1-(colorRevealTimer / colorRevealTimerMax)))
    }
    
    class func getPrevColorRevealLinePosition() -> Double {
        let minX = (EntityManager.getPlayer()!.x) - (Double(screenWidth / 2) / Board.blockSize) - 1
        return minX + (((Double(screenWidth) / Board.blockSize) + 2) * (1-(max(0.0, (colorRevealTimer+currentDelta)) / colorRevealTimerMax)))
    }
    
    class func getRotationValue() -> Double {
        var b = rotateTimer / rotateTimerMax
        let bottomHalf = b < 0.5
        b -= 0.5
        b = abs(b)
        b *= 2
        b = 1.0-b
        b = pow(b, 4)
        b = 1.0-b
        b /= 2
        if(bottomHalf) {
            b *= -1
        }
        b += 0.5
        
        b *= 3.14159 / 2
        if(rotateDirection == "left") {
            b *= -1
        }
        return b
    }
    
    class func getDeathVector() -> CGVector {
        var vector = CGVector.init(dx: 0.0, dy: 0.0)
        
        var b = deathTimer / deathTimerMax
        let bottomHalf = b < 0.5
        b -= 0.5
        b = abs(b)
        b *= 2
        b = 1.0-b
        b = pow(b, 4)
        b = 1.0-b
        b /= 2
        if(bottomHalf) {
            b *= -1
        }
        b += 0.5
        
        vector.dx = CGFloat(1-b)*(Board.spawnPoint.x - CGFloat(EntityManager.getPlayer()!.x))
        vector.dy = CGFloat(1-b)*(Board.spawnPoint.y - CGFloat(EntityManager.getPlayer()!.y))
        
        return vector
    }
    
    class func getDeathRotation() -> Double {
        var b = deathTimer / deathTimerMax
        let bottomHalf = b < 0.5
        b -= 0.5
        b = abs(b)
        b *= 2
        b = 1.0-b
        b = pow(b, 4)
        b = 1.0-b
        b /= 2
        if(bottomHalf) {
            b *= -1
        }
        b += 0.5
        
        b *= (Double(numRotations) * 3.14159) / 2
        if(rotateDirection == "left") {
            b *= -1
        }
        return b
    }
    
    class func getGainAbilityRotation() -> Double {
        if(Block.abilityGainAnimationNum != 0) {
            return 0
        }
        
        var b = (max(GAscreenRotateTimerMin, min(GAscreenRotateTimerMax, 1-(gainAbilityTimer / gainAbilityTimerMax))) - GAscreenRotateTimerMin) / (GAscreenRotateTimerMax - GAscreenRotateTimerMin)
        let bottomHalf = b < 0.5
        b -= 0.5
        b = abs(b)
        b *= 2
        b = 1.0-b
        b = pow(b, 4)
        b = 1.0-b
        b /= 2
        if(bottomHalf) {
            b *= -1
        }
        b += 0.5
        
        b *= (3.14159) * 2
        b *= -1
        return b
    }
    
    private class func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
