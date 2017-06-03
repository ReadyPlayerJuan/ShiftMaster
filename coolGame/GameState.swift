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
    static var currentActionTimes: [Double] = []
    static var newActions: [Action] = []
    
    static var stopPlayerMovement = false
    
    /*static var prevState = "in menu"
    static var prevPlayerState =  "free"
    static var state = "in menu"
    static var playerState = "free"*/
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
    
    class func initGameActions() {
        allActions = [
            Action(ID: 0, length: 1.0, gameAction: GameAction.rotateLeft, stopPlayerMovement: false, subGameActions: [GameAction.rotateStopMovement], subGameActionStarts: [-1]),
            Action(ID: 1, length: 1.0, gameAction: GameAction.rotateRight, stopPlayerMovement: false, subGameActions: [GameAction.rotateStopMovement], subGameActionStarts: [-1]),
            Action(ID: 2, length: 0.8, gameAction: GameAction.rotateStopMovement, stopPlayerMovement: true, subGameActions: [], subGameActionStarts: []),
            Action(ID: 3, length: 4.0, gameAction: GameAction.stageTransitionIn, stopPlayerMovement: true, subGameActions: [], subGameActionStarts: []),
            Action(ID: 4, length: 4.0, gameAction: GameAction.stageTransitionOut, stopPlayerMovement: true, subGameActions: [GameAction.stageTransitionIn], subGameActionStarts: [1]),
            Action(ID: 5, length: 1.5, gameAction: GameAction.changingColor, stopPlayerMovement: true, subGameActions: [], subGameActionStarts: []),
            Action(ID: 6, length: 1.5, gameAction: GameAction.endingStage, stopPlayerMovement: true, subGameActions: [GameAction.stageTransitionOut], subGameActionStarts: [1])
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
            currentActionTimes.append(0)
            
            gameActionFirstFrame(newActions[0].gameAction)
            EntityManager.gameActionFirstFrame(newActions[0].gameAction)
            
            if(newActions[0].subGameActions.count > 0) {
                for i in 0...newActions[0].subGameActions.count-1 {
                    if(newActions[0].subGameActionStarts[i] == -1) {
                        currentActions.append(allActions[newActions[0].subGameActions[i].rawValue])
                        currentActionTimes.append(0)
                        
                        gameActionFirstFrame(newActions[0].subGameActions[i])
                        EntityManager.gameActionFirstFrame(newActions[0].subGameActions[i])
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
            
            let prevProgression = currentActionTimes[index] / action.length
            currentActionTimes[index] += currentDelta
            let progression = currentActionTimes[index] / action.length
            print(action.gameAction)
            
            if(action.subGameActionStarts.count > 0) {
                for subActionIndex in 0...action.subGameActionStarts.count-1 {
                    if(prevProgression <= action.subGameActionStarts[subActionIndex] && progression > action.subGameActionStarts[subActionIndex]) {
                        newActions.append(allActions[action.subGameActions[subActionIndex].rawValue])
                    }
                }
            }
            
            if(progression >= 1) {
                currentActions.remove(at: index)
                currentActionTimes.remove(at: index)
                index -= 1
                
                gameActionLastFrame(action.gameAction)
                EntityManager.gameActionLastFrame(action.gameAction)
            }
            
            index += 1
        }
    }
    
    class func initEntities() {
        //superNode.addChild(SKSpriteNode.init(color: UIColor.red, size: CGSize(width: 100, height: 100)))
        EntityManager.entities = []
        
        let p = Player.init()
        EntityManager.addEntity(entity: p)
        /*
        for row in 0 ... Board.blocks.count-1 {
            for col in 0 ... Board.blocks[0].count-1 {
                EntityManager.addEntity(entity: Board.blocks[row][col]!)
            }
        }
        
        if(Board.otherEntities.count != 0) {
            for e in Board.otherEntities {
                EntityManager.addEntity(entity: e)
            }
        }*/
        for e in Board.entities {
            EntityManager.addEntity(entity: e)
        }
        
        (EntityManager.getPlayer()! as! Player).reset()
        //EntityManager.loadLightSources()
        
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
        
        var gameActions: [GameAction] = []
        for action in currentActions {
            gameActions.append(action.gameAction)
        }
        EntityManager.updateEntities(delta: currentDelta, actions: gameActions)
        
        
        Camera.centerOnPlayer()
        if(currentActions.count > 0) {
            for i in 0...currentActions.count-1 {
                let action = currentActions[i]
                
                switch(action.gameAction) {
                case .rotateLeft:
                    var prog = currentActionTimes[i] / action.length
                    prog = skewToEdges(prog: prog, power: 4)
                    rotateNode.zRotation = -CGFloat(3.14159 / 2 * (1 - prog))
                    break
                case .rotateRight:
                    var prog = currentActionTimes[i] / action.length
                    prog = skewToEdges(prog: prog, power: 4)
                    rotateNode.zRotation = CGFloat(3.14159 / 2 * (1 - prog))
                    break
                default:
                    break
                }
            }
        }
        
        Camera.update(delta: delta)
        InputController.prevTouches = InputController.currentTouches
    }
    
    class func gameActionFirstFrame(_ action: GameAction) {
        switch(action) {
        case .rotateLeft:
            Board.rotateLeft()
            BlockShaders.triangleBlockShader.uniformNamed("u_board_direction")?.floatValue = Float(Board.direction)
            break
        case .rotateRight:
            Board.rotateRight()
            BlockShaders.triangleBlockShader.uniformNamed("u_board_direction")?.floatValue = Float(Board.direction)
            break
        default:
            break
        }
    }
    
    class func gameActionLastFrame(_ action: GameAction) {
        switch(action) {
        case .stageTransitionOut:
            Board.nextStage()
            initEntities()
            BlockShaders.triangleBlockShader.uniformNamed("u_board_direction")?.floatValue = Float(Board.direction)
            break
        default:
            break
        }
    }
    
    class func initShaders() {
        BlockShaders.initShaders()
        PlayerShader.initShader()
        PostShader.initShader()
    }
    
    class func beginGame() {
        inverted = false
        enteringStage = true
        
        stageTransitionType = 0
        //state = "stage transition"
        //playerState = "free"
        stageTransitionTimerMax = stageTransitionTimerMaxDefaults[stageTransitionType]
        stageTransitionTimer = stageTransitionTimerMax
        
        Board.reset()
        Board.nextStage()
        initEntities()
    }
    /*
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
    }*/
    
    class func heightAt(time: Double) -> Double {
        return (GameState.gravity * (time * time)) + GameState.jumpHeight
    }
    /*
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
    */
    class func skewToEdges(prog: Double, power: Double) -> Double {
        var b = prog
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
