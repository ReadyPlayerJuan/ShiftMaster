//
//  Board.swift
//  TestGame
//
//  Created by Erin Seel on 11/24/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import GameplayKit

class Board {
    static var hubStage: Stage!
    static var currentStage: Stage?
    
    static var entities: [Entity] = []
    static var boardWidth: Int!
    static var boardHeight: Int!
    
    static let defaultBlockSize: Double = Double(Int(GameState.screenHeight / 5.3))
    static var blockSize: Double = defaultBlockSize
    static var spawnPoint: CGPoint!
    static var colorTheme = 0
    static var direction = 0
    static let colorVariation = 25.0
    static let grayVariation = 35.0
    
    static var stageID = -1
    
    
    static let gray = CGFloat(0.25)
    static let backgroundColor = UIColor.init(red: gray, green: gray, blue: gray, alpha: 1.0)
    
    class func nextStage() {
        if(GameState.inEditor) {
            currentStage = Stage.loadStage(code: Memory.getStageEdit())
        } else if(GameState.testing || true) {
            blockSize = defaultBlockSize
            if(currentStage == nil) {
                loadAllStages()
                currentStage = Stage.loadTestingArea()
            } else {
                if(currentStage?.children.count != 0) {
                    currentStage = currentStage?.children[GameState.exitTarget]
                } else {
                    currentStage = Stage.loadTestingArea()
                }
            }
        } else {
            blockSize = defaultBlockSize
            if(currentStage == nil) {
                loadAllStages()
                //let ID = Memory.getCurrentStageID()
                let ID = -1 + Int(rand() * 0)
                if(ID == -1) {
                    currentStage = hubStage
                } else {
                    if(hubStage.findStageWithID(ID, baseID: hubStage.ID) != nil) {
                        currentStage = hubStage.findStageWithID(ID, baseID: hubStage.ID)
                    } else {
                        print("saved stage not found")
                        currentStage = hubStage
                    }
                }
            } else {
                if(currentStage?.children.count != 0) {
                    currentStage = currentStage?.children[GameState.exitTarget]
                } else {
                    currentStage = hubStage
                }
            }
        }
        
        colorTheme = currentStage!.colorTheme
        stageID = (currentStage?.ID)!
        Memory.saveCurrentStageID(ID: stageID)
        //Memory.saveAbilityUnlockProgress(progress: GameState.playerAbilities)
        
        direction = 0
        let temp: [[Int]]! = currentStage?.blocks
        spawnPoint = currentStage?.spawnPoint
        
        entities = []
        boardWidth = temp[0].count
        boardHeight = temp.count
        
        //blocks = newEmptyArray(width: temp[0].count, height: temp.count)
        
        for row in 0 ... temp.count-1 {
            for col in 0 ... temp[0].count-1 {
                if(temp[row][col] == -9) {
                    //entities.append(NonsolidBlock.init(x: col, y: row))
                    //blocks[row][col] = Block.init(blockType: 5, color: -1, secondaryColor: -1, dir: -1, x: Double(col), y: Double(row))
                } else if(temp[row][col] == 1) {
                    entities.append(SolidBlock.init(x: col, y: row))
                } else if(temp[row][col] == 0) {
                    entities.append(NonsolidBlock.init(x: col, y: row))
                    //blocks[row][col] = Block.init(blockType: temp[row][col], color: -1, secondaryColor: -1, dir: -1, x: Double(col), y: Double(row))
                } else if(temp[row][col] < 10 && temp[row][col] > 1) {
                    entities.append(ColoredBlock.init(x: col, y: row, colorIndex: temp[row][col]-2))
                    //blocks[row][col] = Block.init(blockType: 2, color: temp[row][col]-2, secondaryColor: -1, dir: -1, x: Double(col), y: Double(row))
                } else if(temp[row][col] == 99) {
                    entities.append(NonsolidBlock.init(x: col, y: row))
                    entities.append(HazardBlock.init(x: col, y: row))
                    //blocks[row][col] = Block.init(blockType: 6, color: -1, secondaryColor: -1, dir: -1, x: Double(col), y: Double(row))
                } else if(temp[row][col] >= 10) {
                    entities.append(NonsolidBlock.init(x: col, y: row))
                    
                    let s = temp[row][col]
                    let direction = Int(Double(s)/100.0) % 4
                    var colorIndex = Int(Double(s-(100*direction))/10.0)
                    var colorIndex2 = s - (100*direction) - (colorIndex*10)
                    colorIndex -= 2
                    colorIndex2 -= 2
                    
                    if(colorIndex2 == 7) {
                        entities.append(InvertBlock.init(x: col, y: row, direction: direction))
                    } else {
                        if(direction >= 4) {
                        } else {
                            entities.append(ColorChangeBlock.init(x: col, y: row, colorIndex: colorIndex2, direction: direction))
                        }
                    }
                } else if(temp[row][col] < 0) {
                    entities.append(NonsolidBlock.init(x: col, y: row))
                    let direction = (abs(temp[row][col])/10)-1
                    entities.append(ExitBlock.init(x: col, y: row, direction: direction))
                }
            }
        }
        
        initEntities()
        loadHazardBlockData()
    }
    
    class func initEntities() {
        EntityManager.entities = []
        
        let p = Player.init()
        EntityManager.addEntity(entity: p)
        
        for e in entities {
            EntityManager.addEntity(entity: e)
        }
        
        (EntityManager.getPlayer()! as! Player).reset()
        
        EntityManager.sortEntities()
        EntityManager.redrawEntities(node: GameState.drawNode, name: "all")
    }
    
    class func loadHazardBlockData() {
        for entity in EntityManager.entities {
            if(entity.name == "hazard block") {
                (entity as! HazardBlock).extendR = false
                (entity as! HazardBlock).extendL = false
                (entity as! HazardBlock).extendT = false
                (entity as! HazardBlock).extendB = false
                (entity as! HazardBlock).extendBR = false
                (entity as! HazardBlock).extendBL = false
                (entity as! HazardBlock).extendTR = false
                (entity as! HazardBlock).extendTL = false
            }
        }
        for entity in EntityManager.entities {
            if(entity.name == "hazard block") {
                for entity2 in EntityManager.entities {
                    if(entity2.name == "hazard block") {
                        if(entity2.x == entity.x + 1 && entity2.y == entity.y) {
                            (entity as! HazardBlock).extendR = true
                        } else if(entity2.x == entity.x - 1 && entity2.y == entity.y) {
                            (entity as! HazardBlock).extendL = true
                        } else if(entity2.x == entity.x && entity2.y == entity.y + 1) {
                            (entity as! HazardBlock).extendB = true
                        } else if(entity2.x == entity.x && entity2.y == entity.y - 1) {
                            (entity as! HazardBlock).extendT = true
                        }
                    }
                }
            }
        }
        for e in EntityManager.entities {
            if(e.name == "hazard block") {
                let entity = e as! HazardBlock
                for entity2 in EntityManager.entities {
                    if(entity2.name == "hazard block") {
                        if(entity.extendR && entity.extendB && entity2.x == entity.x + 1 && entity2.y == entity.y + 1) {
                            entity.extendBR = true
                        } else if(entity.extendL && entity.extendB && entity2.x == entity.x - 1 && entity2.y == entity.y + 1) {
                            entity.extendBL = true
                        } else if(entity.extendR && entity.extendT && entity2.x == entity.x + 1 && entity2.y == entity.y - 1) {
                            entity.extendTR = true
                        } else if(entity.extendL && entity.extendT && entity2.x == entity.x - 1 && entity2.y == entity.y - 1) {
                            entity.extendTL = true
                        }
                    }
                }
            }
        }
    }
    
    class func reset() {
        currentStage = nil
        direction = 0
        entities = []
        colorTheme = 0
        blockSize = defaultBlockSize
    }
    
    class func rotateLeft() {
        let temp = boardWidth
        boardWidth = boardHeight
        boardHeight = temp
        
        direction -= 1
        if(direction < 0) {
            direction += 4
        }
    }
    
    class func rotateRight() {
        let temp = boardWidth
        boardWidth = boardHeight
        boardHeight = temp
        
        direction += 1
        if(direction > 3) {
            direction -= 4
        }
    }
    
    class func rotate() {
        /*
         if(GameState.rotateDirection == "right") {
            direction += 1
            direction %= 4
            
            var temp = newEmptyArray(width: blocks.count, height: blocks[0].count)
            for row in 0 ... blocks[0].count-1 {
                for c in 0 ... blocks.count-1 {
                    let col = blocks.count-1 - c
                    temp[row][col] = blocks[blocks.count-1-col][row]
                }
            }
            
            for entity in EntityManager.entities {
                if(entity.autoRotate) {
                    var tempCoords = [entity.x, entity.y]
                    entity.x = Double(blocks.count-1)-tempCoords[1]
                    entity.y = tempCoords[0]
                    
                    entity.nextX = entity.x
                    entity.nextY = entity.y
                    
                    let temp = entity.xVel
                    entity.xVel = entity.yVel * -1
                    entity.yVel = temp
                }
                
                entity.rotate(direction: "right")
                
                entity.loadSprite()
                entity.updateSprite()
            }
            EntityManager.redrawEntities(node: GameState.drawNode, name: "all")
            
            let p = (EntityManager.getPlayer()! as! Player)
            var tempVels = [p.prevXVel, p.prevYVel]
            p.prevXVel = -tempVels[1]
            p.prevYVel = tempVels[0]
            
            blocks = temp
         } else {
            direction -= 1
            if(direction < 0) {
                direction += 4
            }
            
            var temp = newEmptyArray(width: blocks.count, height: blocks[0].count)
            for row in 0 ... blocks[0].count-1 {
                for col in 0 ... blocks.count-1 {
                    temp[row][col] = blocks[col][blocks[0].count-1-row]
                }
            }
            
            for entity in EntityManager.entities {
                if(entity.autoRotate) {
                    var tempCoords = [entity.x, entity.y]
                    entity.x = tempCoords[1]
                    entity.y = Double(blocks[0].count-1)-tempCoords[0]
                    
                    entity.nextX = entity.x
                    entity.nextY = entity.y
                    
                    let temp = entity.xVel
                    entity.xVel = entity.yVel
                    entity.yVel = temp * -1
                }
                
                entity.rotate(direction: "left")
                
                entity.loadSprite()
                entity.updateSprite()
            }
            EntityManager.redrawEntities(node: GameState.drawNode, name: "all")
            
            let p = (EntityManager.getPlayer()! as! Player)
            var tempVels = [p.prevXVel, p.prevYVel]
            p.prevXVel = tempVels[1]
            p.prevYVel = -tempVels[0]
            
            blocks = temp
         }*/
    }
    /*
    class func findMovingBlockAtPoint(x: Double, y: Double) -> MovingBlock? {
        for entity in otherEntities {
            if(entity.name == "moving block") {
                if(entity.x == x && entity.y == y) {
                    return entity as? MovingBlock
                }
            }
        }
        
        return nil
    }*/
    /*
    class func rotatePoint(_ point: CGPoint, clockwise: Bool) -> CGPoint {
        if(clockwise) {
            var tempCoords = [Double(point.x), Double(point.y)]
            var tempPoint = CGPoint()
            tempPoint.x = CGFloat(Double(blocks.count-1)-tempCoords[1])
            tempPoint.y = CGFloat(tempCoords[0])
            return tempPoint
        } else {
            var tempCoords = [Double(point.x), Double(point.y)]
            var tempPoint = CGPoint()
            tempPoint.x = CGFloat(tempCoords[1])
            tempPoint.y = CGFloat(Double(blocks[0].count-1)-tempCoords[0])
            return tempPoint
        }
    }*/
    /*
    class func sortOtherEntities() -> [Entity] {
        var temp = [Entity]()
        
        for e in otherEntities {
            var index = 0
            if(temp.count > 0) {
                while(index < temp.count && temp[index].y >= e.y) {
                    index += 1
                }
            }
            
            temp.insert(e, at: index)
        }
        
        return temp
    }*/
    /*
    private class func newEmptyArray(width: Int, height: Int) -> [[Block?]] {
        var temp = [[Block?]]()
        for row in 0 ... height-1 {
            temp.append([Block]())
            for col in 0 ... width-1 {
                if(col != -69) {
                    temp[row].append(nil)
                }
            }
        }
        return temp
    }*/
    
    private class func loadAllStages() {
        let stage =   [ [1, 1, 1, 1, 1, 1, 1],
                        [1, 3, 0, 0, 0, 0, 1],
                        [1, 0, 0, 0, 0, 0, 1],
                        [1,-41,0, 0, 0, 0, 1],
                        [1, 0, 0, 0,-11,0, 1],
                        [1, 1, 1, 1, 1, 1, 1] ]
        let spawnPoint = CGPoint(x: 2, y: 4)
        let exitTargets = [[4, 4, 0], [1, 3, 1]]
        let otherEntities: [Entity] = []
        
        hubStage = Stage.init(withBlocks: stage, entities: otherEntities, spawn: spawnPoint, withName: "hub", exits: exitTargets, colorTheme: 1)
        hubStage.playShowColorAnimation = true
        StageSet1.loadStages(base: hubStage)
        //StageSet3.loadStages(base: hubStage)
    }
    
    private class func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
