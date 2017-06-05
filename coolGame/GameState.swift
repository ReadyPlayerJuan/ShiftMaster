//
//  GameState.swift
//  Drawing Test
//
//  Created by Erin Seel on 11/26/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

struct Action {
    var ID: Int
    var length: Double
    var gameAction: GameAction
    
    var stopPlayerMovement: Bool
    
    var subGameActions: [GameAction]
    var subGameActionStarts: [Double]
}

enum GameAction: Int {
    case rotateLeft = 0
    case rotateRight = 1
    case rotateStopMovement = 2
    case stageTransitionIn = 3
    case stageTransitionOut = 4
    case changingColor = 5
    case endingStage = 6
    case respawningPlayer = 7
}

class GameState {
    static let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.width
    static let screenWidth = UIScreen.main.bounds.width
    
    static var gamescene: GameScene!
    static var editorscene: EditorScene!
    
    static var superNode: SKNode!
    static var drawNode: SKNode!
    static var rotateNode: SKNode!
    
    static var allActions: [Action] = []
    static var currentActions: [Action] = []
    static var currentActionTimers: [Double] = []
    static var currentActionPercents: [Double] = []
    static var newActions: [Action] = []
    
    static var stopPlayerMovement = false
    
    static var maxDeathRotation = 0.0
    static var stageTransitionAngle = 0.0
    
    /*static var prevState = "in menu"
    static var prevPlayerState =  "free"
    static var state = "in menu"
    static var playerState = "free"*/
    static var inEditor = false
    static var currentlyEditing = false
    
    static var currentDelta = 0.0
    static var ignoreDelta = true
    
    static var exitTarget = 0
    
    /*static var firstFrame = false
    static var lastFrame = false
    
    static var enteringStage = true
    static var stageTransitionTimer = 0.0
    static var stageTransitionTimerMaxDefaults = [2.0, 4.0]
    static var stageTransitionTimerMax = stageTransitionTimerMaxDefaults[0]
    static var stageTransitionAngle = 0.0
    static var stageTransitionType = 0
    
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
    
     static let GArotateTimerMin = 0.0
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
    
    class func initGameActions() {
        allActions = [
            Action(ID: 0, length: 1.0, gameAction: GameAction.rotateLeft, stopPlayerMovement: false, subGameActions: [GameAction.rotateStopMovement], subGameActionStarts: [-1]),
            Action(ID: 1, length: 1.0, gameAction: GameAction.rotateRight, stopPlayerMovement: false, subGameActions: [GameAction.rotateStopMovement], subGameActionStarts: [-1]),
            Action(ID: 2, length: 0.8, gameAction: GameAction.rotateStopMovement, stopPlayerMovement: true, subGameActions: [], subGameActionStarts: []),
            Action(ID: 3, length: 6.0, gameAction: GameAction.stageTransitionIn, stopPlayerMovement: true, subGameActions: [], subGameActionStarts: []),
            Action(ID: 4, length: 6.0, gameAction: GameAction.stageTransitionOut, stopPlayerMovement: true, subGameActions: [GameAction.stageTransitionIn], subGameActionStarts: [1]),
            Action(ID: 5, length: 1.5, gameAction: GameAction.changingColor, stopPlayerMovement: true, subGameActions: [], subGameActionStarts: []),
            Action(ID: 6, length: 1.5, gameAction: GameAction.endingStage, stopPlayerMovement: true, subGameActions: [GameAction.stageTransitionOut], subGameActionStarts: [1]),
            Action(ID: 7, length: 3.0, gameAction: GameAction.respawningPlayer, stopPlayerMovement: true, subGameActions: [], subGameActionStarts: [])
        ]
    }
    
    class func gameAction(_ action: GameAction) {
        for a in newActions {
            if(a.gameAction == action) {
                return
            }
        }
        
        newActions.append(allActions[action.rawValue])
    }
    
    class func updateGameActions() {
        while(newActions.count > 0) {
            currentActions.append(newActions[0])
            currentActionTimers.append(0)
            
            gameActionFirstFrame(newActions[0].gameAction)
            EntityManager.gameActionFirstFrame(newActions[0].gameAction)
            print("started", newActions[0].gameAction)
            
            if(newActions[0].subGameActions.count > 0) {
                for i in 0...newActions[0].subGameActions.count-1 {
                    if(newActions[0].subGameActionStarts[i] == -1) {
                        currentActions.append(allActions[newActions[0].subGameActions[i].rawValue])
                        currentActionTimers.append(0)
                        
                        gameActionFirstFrame(newActions[0].subGameActions[i])
                        EntityManager.gameActionFirstFrame(newActions[0].subGameActions[i])
                        print("started", newActions[0].subGameActions[i])
                    }
                }
            }
            
            newActions.remove(at: 0)
        }
        
        
        stopPlayerMovement = false
        
        var index = 0
        while(index < currentActions.count) {
            let action = currentActions[index]
            
            if(action.stopPlayerMovement) {
                stopPlayerMovement = true
            }
            
            let prevProgression = currentActionTimers[index] / action.length
            currentActionTimers[index] += currentDelta
            let progression = currentActionTimers[index] / action.length
            
            if(action.subGameActionStarts.count > 0) {
                for subActionIndex in 0...action.subGameActionStarts.count-1 {
                    if(prevProgression <= action.subGameActionStarts[subActionIndex] && progression > action.subGameActionStarts[subActionIndex]) {
                        newActions.append(allActions[action.subGameActions[subActionIndex].rawValue])
                    }
                }
            }
            
            if(progression >= 1) {
                currentActions.remove(at: index)
                currentActionTimers.remove(at: index)
                index -= 1
                
                gameActionLastFrame(action.gameAction)
                EntityManager.gameActionLastFrame(action.gameAction)
                print("ended", action.gameAction)
            }
            
            index += 1
        }
    }
    
    class func initEntities() {
        EntityManager.entities = []
        
        let p = Player.init()
        EntityManager.addEntity(entity: p)
        
        for e in Board.entities {
            EntityManager.addEntity(entity: e)
        }
        
        (EntityManager.getPlayer()! as! Player).reset()
        
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
        
        
        InputController.update()
        
        
        updateGameActions()
        
        //var gameActions: [GameAction] = []
        currentActionPercents = []
        if(currentActions.count > 0) {
            for i in 0...currentActions.count-1 {
                let action = currentActions[i]
                //gameActions.append(action.gameAction)
                currentActionPercents.append(currentActionTimers[i] / action.length)
            }
        }
        EntityManager.updateEntities(delta: currentDelta)
        
        if(currentActions.count > 0) {
            for i in 0...currentActions.count-1 {
                let action = currentActions[i]
                
                switch(action.gameAction) {
                case .rotateLeft:
                    Camera.centerOnPlayer()
                    var pct = currentActionPercents[i]
                    pct = skewToEdges(pct: pct, power: 4)
                    rotateNode.zRotation = -CGFloat(3.14159 / 2 * (1 - pct))
                    break
                case .rotateRight:
                    Camera.centerOnPlayer()
                    var pct = currentActionPercents[i]
                    pct = skewToEdges(pct: pct, power: 4)
                    rotateNode.zRotation = CGFloat(3.14159 / 2 * (1 - pct))
                    break
                case .respawningPlayer:
                    var pct = currentActionPercents[i]
                    pct = skewToEdges(pct: pct, power: 4)
                    rotateNode.zRotation = CGFloat(maxDeathRotation * (1 - pct))
                    
                    let spawnPoint = CGPoint(x: -Double(Board.spawnPoint.x) * Board.blockSize, y: Double(Board.spawnPoint.y) * Board.blockSize)
                    Camera.centerOnPlayer()
                    Camera.centerOnPoint(CGPoint(x: CGFloat(Camera.targetX * (1 - pct)) + (spawnPoint.x * CGFloat(pct)), y: CGFloat(Camera.targetY * (1 - pct)) + (spawnPoint.y * CGFloat(pct))))
                case .stageTransitionOut:
                    let pct = currentActionPercents[i]
                    let zoomOutEnd = 0.4
                    let moveAwayStart = 0.45
                    
                    if(pct < zoomOutEnd) {
                        let pct2 = pct / zoomOutEnd
                        Camera.targetZoom = 1 - (0.5 * skewToEdges(pct: pct2, power: 3))
                    } else {
                        let pct2 = min(1, (pct - zoomOutEnd) / (1 - zoomOutEnd))
                        Camera.targetZoom = 0.5 + (0.5 * skewToEdges(pct: pct2, power: 3))
                    }
                    
                    if(pct < moveAwayStart) {
                        //let pct2 = pct / moveAwayStart
                        //Camera.targetZoom = 1 - (0.5 * skewToEdges(pct: pct2, power: 3))
                    } else {
                        let pct2 = (pct - moveAwayStart) / (1 - moveAwayStart)
                        Camera.centerOnPlayer()
                        Camera.targetX += pow(pct2, 3) * cos(stageTransitionAngle) * Board.blockSize * 200
                        Camera.targetY += pow(pct2, 3) * sin(stageTransitionAngle) * Board.blockSize * 200
                        rotateNode.zRotation = CGFloat(pow(pct2, 3.0) * 20)
                    }
                    break
                case .stageTransitionIn:
                    let pct = 1 - currentActionPercents[i]
                    let zoomOutEnd = 0.4
                    let moveAwayStart = 0.45
                    
                    if(pct < zoomOutEnd) {
                        let pct2 = pct / zoomOutEnd
                        Camera.targetZoom = 1 - (0.5 * skewToEdges(pct: pct2, power: 3))
                    } else {
                        let pct2 = min(1, (pct - zoomOutEnd) / (1 - zoomOutEnd))
                        Camera.targetZoom = 0.5 + (0.5 * skewToEdges(pct: pct2, power: 3))
                    }
                    
                    if(pct < moveAwayStart) {
                        //let pct2 = pct / moveAwayStart
                        //Camera.targetZoom = 1 - (0.5 * skewToEdges(pct: pct2, power: 3))
                    } else {
                        let pct2 = (pct - moveAwayStart) / (1 - moveAwayStart)
                        Camera.centerOnPlayer()
                        Camera.targetX += pow(pct2, 3) * cos(stageTransitionAngle) * Board.blockSize * 200
                        Camera.targetY += pow(pct2, 3) * sin(stageTransitionAngle) * Board.blockSize * 200
                        rotateNode.zRotation = CGFloat(pow(pct2, 3.0) * 20)
                    }
                    break
                default:
                    Camera.centerOnPlayer()
                    break
                }
            }
        } else {
            Camera.centerOnPlayer()
        }
        
        Camera.update(delta: delta)
        InputController.prevTouches = InputController.currentTouches
    }
    
    class func gameActionFirstFrame(_ action: GameAction) {
        switch(action) {
        case .rotateLeft:
            Board.rotateLeft()
            BlockShaders.updateDirection()
            break
        case .rotateRight:
            Board.rotateRight()
            BlockShaders.updateDirection()
            break
        case .respawningPlayer:
            switch(Board.direction) {
            case 0:
                maxDeathRotation = 0
                break
            case 1:
                Board.rotateLeft()
                EntityManager.gameActionFirstFrame(GameAction.rotateLeft)
                maxDeathRotation = -3.14159 / 2.0
                break
            case 2:
                Board.rotateRight()
                EntityManager.gameActionFirstFrame(GameAction.rotateRight)
                Board.rotateRight()
                EntityManager.gameActionFirstFrame(GameAction.rotateRight)
                maxDeathRotation = 3.14159 * sign(rand() - 0.5)
                break
            case 3:
                Board.rotateRight()
                EntityManager.gameActionFirstFrame(GameAction.rotateRight)
                maxDeathRotation = 3.14159 / 2.0
                break
            default:
                break
            }
            BlockShaders.updateDirection()
            break
        case .stageTransitionOut:
            stageTransitionAngle = rand() * 3.14159 * 2
            break
        case .stageTransitionIn:
            stageTransitionAngle = rand() * 3.14159 * 2
            break
        default:
            break
        }
    }
    
    class func gameActionLastFrame(_ action: GameAction) {
        switch(action) {
        case .respawningPlayer:
            break
        case .stageTransitionOut:
            updateGameActions()
            Board.nextStage()
            initEntities()
            BlockShaders.updateDirection()
            break
        case .stageTransitionIn:
            Camera.targetZoom = 1
            rotateNode.zRotation = 0
            break
        default:
            break
        }
    }
    
    class func initShaders() {
        BlockShaders.initShaders()
        PlayerShaders.initShaders()
        PostShaders.initShaders()
    }
    
    class func beginGame() {
        Board.reset()
        Board.nextStage()
        initEntities()
    }
    
    class func heightAt(time: Double) -> Double {
        return (GameState.gravity * (time * time)) + GameState.jumpHeight
    }
    
    class func skewToEdges(pct: Double, power: Double) -> Double {
        var b = pct
        let bottomHalf = b < 0.5
        b -= 0.5
        b = abs(b)
        b *= 2
        b = 1.0-b
        b = pow(b, power)
        b = 1.0-b
        b /= 2
        if(bottomHalf) {
            b *= -1
        }
        b += 0.5
        return b
    }
    
    private class func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
