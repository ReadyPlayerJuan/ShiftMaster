//
//  Player.swift
//  Drawing Test
//
//  Created by Erin Seel on 11/25/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import GameplayKit

class Player: Entity {
    static var maxAbilities = 0
    static let allAbilities = ["rotating", "changing color", "inverting"]
    static var currentAbilities = [String]()
    
    var movementTotal = 0.0
    
    var rotation = 0.0
    var rotationVel = 0.0
    
    var verticalMovementTimer = 0.0
    var horizontalMovementTimer = 0.0
    
    let colAcc = 0.0001
    
    var movingLeft = false
    var movingRight = false
    var jumping = false
    var canHingeLeft = false
    var canHingeRight = false
    var hitCeiling = false
    
    var hinging = false
    var hingeDirection = "left"
    
    var colorIndex = -1
    var newColorIndex = -1
    
    var respawnEffect: SKShapeNode!
    var deathParticles: [SKShapeNode] = []
    var deathParticleInfo: [[Double]] = [[]]
    var deathParticleColor: UIColor = UIColor.clear
    var prevXVel: Double = 0.0
    var prevYVel: Double = 0.0
    
    override init() {
        super.init()
        
        collisionType = 0
        collidesWithType = [0, 10, 11, 12, 13, 14, 15]
        collisionPriority = -1
        zPos = 99
        controllable = true
        isDynamic = true
        name = "player"
        hitboxType = HitboxType.player
        
        defaultSpriteColor = UIColor.white
        shader = PlayerShader.shader
        
        reset()
        
        load()
    }
    
    func reset() {
        x = Double(Board.spawnPoint.x)
        y = Double(Board.spawnPoint.y)
        nextX = x
        nextY = y
        xVel = 0.0
        yVel = 0.0
        verticalMovementTimer = 0
        horizontalMovementTimer = 0
        
        colorIndex = -1
        collidesWithType = [0, 10, 11, 12, 13, 14, 15]
        
        load()
        /*if(GameState.time > 0.5 && !GameState.inEditor && !(GameState.state == "stage transition")) {
            sprite.removeFromParent()
            loadSprite()
            EntityManager.redrawEntities(node: GameState.drawNode, name: "player")
        } else {
            loadSprite()
        }*/
    }
    
    override func update(delta: TimeInterval, actions: [GameAction]) {
        checkInputForMovement()
        
        print(x, y)
        print(sprite.position)
        if(!GameState.stopPlayerMovement) {
            if(hinging) {
                rotate(delta: delta)
            } else {
                move(delta: delta)
            }
        } else {
            
        }
        
        if(actions.contains(GameAction.changingColor) || actions.contains(GameAction.endingStage)) {
            nextX = Double(Int(x + 0.5))
            x = nextX
        }
    }
    
    override func gameActionFirstFrame(_ action: GameAction) {
        switch(action) {
        case .rotateLeft:
            hinging = false
            sprite.zRotation = 0
            super.gameActionFirstFrame(action)
            break
        case .rotateRight:
            hinging = false
            sprite.zRotation = 0
            super.gameActionFirstFrame(action)
            break
        default:
            break
        }
    }
    
    override func gameActionLastFrame(_ action: GameAction) {
        switch(action) {
        case .rotateLeft:
            //hinging = false
            break
        case .rotateRight:
            //hinging = false
            break
        case .changingColor:
            colorIndex = newColorIndex
            newColorIndex = -1
            defaultSpriteColor = ColorTheme.getColor(colorIndex: colorIndex, colorVariation: false)
            
            load()
            EntityManager.redrawEntities(node: GameState.drawNode, name: "player")
            
            collidesWithType = [0]
            collidesWithType.append(colorIndex+10)
            break
        case .endingStage:
            sprite.alpha = 0
            break
        default:
            break
        }
    }
    
    func getCenter() -> CGPoint {
        /*if(GameState.playerState == "rotating" || (GameState.state == "rotating" && GameState.rotateTimer == GameState.rotateTimerMax)) {
            if(GameState.hingeDirection == "right") {
                return CGPoint.init(x: x + 1.0 - ((sqrt(3.0) / 3.0) * cos((rotation - 30) * (3.14159 / 180.0))), y: y + ((sqrt(3.0) / 3.0) * sin((rotation - 30) * (3.14159 / 180.0))))
            } else {
                return CGPoint.init(x: x + ((sqrt(3.0) / 3.0) * cos((rotation + 30) * (3.14159 / 180.0))), y: y - ((sqrt(3.0) / 3.0) * sin((rotation + 30) * (3.14159 / 180.0))))
            }
        } else {
            return CGPoint.init(x: x + 0.5, y: y - (sqrt(3.0) / 6.0))
        }*/
        return CGPoint(x: x, y: y)
    }
    
    override func updateAttributes() {
        sprite.setValue(SKAttributeValue(vectorFloat2: vector_float2(Float(x), Float(y))), forAttribute: "a_player_position")
    }
    
    override func load() {
        if(sprite != nil && sprite.parent != nil) {
            sprite.removeFromParent()
        }
        
        let temp = SKSpriteNode.init(color: defaultSpriteColor, size: CGSize(width: Board.blockSize, height: Board.blockSize))
        temp.zPosition = zPos
        temp.shader = shader
        
        sprite = temp
    }
    /*
    override func loadSprite() {
        if(GameState.currentlyEditing) {
            let path1 = UIBezierPath.init()
            let size = 0.05
            path1.move(to: CGPoint(x: 0, y: Double(Board.blockSize)*size))
            path1.addLine(to: CGPoint(x: Double(Board.blockSize)*size, y: 0))
            path1.addLine(to: CGPoint(x: Double(Board.blockSize)*(1), y: Double(Board.blockSize)*(1-size)))
            path1.addLine(to: CGPoint(x: Double(Board.blockSize)*(1-size), y: Double(Board.blockSize)*(1)))
            
            let line1 = SKShapeNode.init(path: path1.cgPath)
            line1.fillColor = UIColor.red
            line1.strokeColor = UIColor.clear
            line1.zPosition = zPos
            
            let path2 = UIBezierPath.init()
            path2.move(to: CGPoint(x: Double(Board.blockSize), y: Double(Board.blockSize)*size))
            path2.addLine(to: CGPoint(x: Double(Board.blockSize)*(1-size), y: 0))
            path2.addLine(to: CGPoint(x: Double(Board.blockSize)*(0), y: Double(Board.blockSize)*(1-size)))
            path2.addLine(to: CGPoint(x: Double(Board.blockSize)*(size), y: Double(Board.blockSize)*(1)))
            
            let line2 = SKShapeNode.init(path: path2.cgPath)
            line2.fillColor = UIColor.red
            line2.strokeColor = UIColor.clear
            
            line1.position = CGPoint(x: x * Double(Board.blockSize), y: -y * Double(Board.blockSize))
            sprite = line1
            line1.addChild(line2)
        } else {
            sprite.removeFromParent()
            
            let temp = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: 0, y: 0), rotation: 0.0, size: Double(Board.blockSize)))
            temp.fillColor = color
            temp.strokeColor = UIColor.clear
            temp.position = CGPoint(x: x * Double(Board.blockSize), y: -y * Double(Board.blockSize))
            temp.zPosition = zPos
            
            sprite = temp
        }
    }*/
    /*
    override func updateSprite() {
        if(GameState.currentlyEditing) {
        } else if(GameState.state == "inverting") {
            let n = 0.1
            var alpha = abs(((GameState.inversionTimer / GameState.inversionTimerMax) - 0.5) * 2)
            alpha = alpha-1
            alpha = max(0, alpha + n)
            alpha /= n
            
            //sprite[0].alpha = CGFloat(alpha + 1)
            let w = max(0, (GameState.getInversionLinePosition()-x))
            
            var path = UIBezierPath.init()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: min(w, 0.5) * Board.blockSize, y: 0))
            path.addLine(to: CGPoint(x: min(w, 0.5) * Board.blockSize, y: min(w, 0.5) * sqrt(3.0) * Board.blockSize))
            let s2 = SKShapeNode.init(path: path.cgPath)
            s2.fillColor = loadColor(colIndex: colorIndex)
            s2.strokeColor = UIColor.clear
            
            let w2 = max(0, min(0.5, w - 0.5))
            
            path = UIBezierPath.init()
            path.move(to: CGPoint(x: 0.5 * Board.blockSize, y: 0))
            path.addLine(to: CGPoint(x: 0.5 * Board.blockSize, y: 0.5 * sqrt(3.0) * Board.blockSize))
            path.addLine(to: CGPoint(x: (0.5 + w2) * Board.blockSize, y: (0.5 - w2) * sqrt(3.0) * Board.blockSize))
            path.addLine(to: CGPoint(x: (0.5 + w2) * Board.blockSize, y: 0))
            let s3 = SKShapeNode.init(path: path.cgPath)
            s3.fillColor = loadColor(colIndex: colorIndex)
            s3.strokeColor = UIColor.clear
            
            
            sprite.removeAllChildren()
            sprite.addChild(s2)
            sprite.addChild(s3)
            
            
            if(GameState.getInversionLinePosition() > x+1) {
                color = loadColor(colIndex: colorIndex)
                sprite.fillColor = color
            }
        } else if(GameState.playerState == "free") {
            sprite.position = CGPoint(x: x * Double(Board.blockSize), y: -y * Double(Board.blockSize))
            
            sprite.alpha = 1.0
            sprite.zRotation = 0.0
        } else if(GameState.playerState == "rotating") {
            if(GameState.hingeDirection == "left") {
                let pi = 3.14159265
                var rotationRad = (rotation * 2 * pi) / 360.0
                
                if(GameState.firstFrame) {
                    rotationRad = (30 * 2 * pi) / 360.0
                }
                
                sprite.zRotation = CGFloat(rotationRad)
                sprite.position = CGPoint(x: x * Double(Board.blockSize), y: -y * Double(Board.blockSize))
            } else {
                let pi = 3.14159265
                var rotationRad = (rotation * 2 * pi) / 360.0
                
                if(GameState.firstFrame) {
                    rotationRad = (-30 * 2 * pi) / 360.0
                }
                
                sprite.zRotation = CGFloat(rotationRad)
                sprite.position = CGPoint(x: (x + (1 - cos(rotationRad))) * Double(Board.blockSize), y: -(y + sin(rotationRad)) * Double(Board.blockSize))
            }
        } else if(GameState.playerState == "changing color") {
            sprite.position = CGPoint(x: x * Double(Board.blockSize), y: -y * Double(Board.blockSize))
            sprite.zRotation = 0.0
            
            updateColorChangeEffect()
        } else if(GameState.playerState == "respawning") {
            sprite.position = CGPoint(x: x * Double(Board.blockSize), y: -y * Double(Board.blockSize))
            sprite.fillColor = UIColor.clear
        } else if(GameState.state == "stage transition") {
            if(GameState.enteringStage) {
                sprite.alpha = 1.0
            } else {
                sprite.alpha = 0.0
            }
        } else if(GameState.state == "gaining ability") {
            if(1 - (GameState.gainAbilityTimer/GameState.gainAbilityTimerMax) < GameState.GAscreenFloodTimerMax) {
                sprite.alpha = 0.0
            } else {
                sprite.alpha = 1.0
            }
        }
    }*/
        
    func loadColor(colIndex: Int) -> UIColor {
        if(colIndex == -1) {
            let blockVariation = 0//rand()*Double(Board.colorVariation)
            
            //if((GameState.inverted && GameState.state != "inverting") || (!GameState.inverted && GameState.state == "inverting")) {
                //return UIColor(red: 0.0+(CGFloat(blockVariation)/255.0), green: 0.0+(CGFloat(blockVariation)/255.0), blue: 0.0+(CGFloat(blockVariation)/255.0), alpha: 1.0)
            //} else {
                return UIColor(red: 1.0-(CGFloat(blockVariation)/255.0), green: 1.0-(CGFloat(blockVariation)/255.0), blue: 1.0-(CGFloat(blockVariation)/255.0), alpha: 1.0)
            //}
        } else {
            let blockVariation = 0//(Board.colorVariation/2.0) - (rand()*Board.colorVariation)
            var colorArray = ColorTheme.colors[Board.colorTheme][colIndex]
            
            for index in 0 ... 2 {
                colorArray[index] = max(min(colorArray[index] + Int(blockVariation), 255), 0)
            }
            
            //if((GameState.inverted && GameState.state != "inverting") || (!GameState.inverted && GameState.state == "inverting")) {
                //return UIColor(red: 1-(CGFloat(colorArray[0]) / 255.0), green: 1-(CGFloat(colorArray[1]) / 255.0), blue: 1-(CGFloat(colorArray[2]) / 255.0), alpha: 1.0)
            //} else {
                return UIColor(red: CGFloat(colorArray[0]) / 255.0, green: CGFloat(colorArray[1]) / 255.0, blue: CGFloat(colorArray[2]) / 255.0, alpha: 1.0)
            //}
        }
    }
    
    func getColor(colIndex: Int) -> [CGFloat] {
        if(colIndex == -1) {
            let blockVariation = 0//rand()*Double(Board.colorVariation)
            
            //if(GameState.inverted || (!GameState.inverted && GameState.state == "inverting")) {
                //return [0.0+(CGFloat(blockVariation)/255.0), 0.0+(CGFloat(blockVariation)/255.0), 0.0+(CGFloat(blockVariation)/255.0)]
            //} else {
                return [1.0-(CGFloat(blockVariation)/255.0), 1.0-(CGFloat(blockVariation)/255.0), 1.0-(CGFloat(blockVariation)/255.0)]
            //}
        } else {
            let blockVariation = 0//(Board.colorVariation/2.0) - (rand()*Board.colorVariation)
            var colorArray = ColorTheme.colors[Board.colorTheme][colIndex]
            
            for index in 0 ... 2 {
                colorArray[index] = max(min(colorArray[index] + Int(blockVariation), 255), 0)
            }
            
            //if(GameState.inverted || (!GameState.inverted && GameState.state == "inverting")) {
                //return [1-(CGFloat(colorArray[0]) / 255.0), 1-(CGFloat(colorArray[1]) / 255.0), 1-(CGFloat(colorArray[2]) / 255.0)]
            //} else {
                return [CGFloat(colorArray[0]) / 255.0, CGFloat(colorArray[1]) / 255.0, CGFloat(colorArray[2]) / 255.0]
            //}
        }
    }
    
    override func checkForCollision() {
        collide()
    }
    
    override func move() {
        movementTotal += hypot(x - nextX, y - nextY)
        
        super.move()
        
        if(!hinging) {
            sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
        } else {
            if(hingeDirection == "left") {
                sprite.zRotation = CGFloat(rotation * 3.14159 / 180)
                sprite.position = CGPoint(x: (x - 0.5 + ((sqrt(2) / 2) * cos((rotation + 45) * 3.14159 / 180))) * Board.blockSize, y: -(y + 0.5 - ((sqrt(2) / 2) * sin((rotation + 45) * 3.14159 / 180))) * Board.blockSize)
            } else {
                sprite.zRotation = CGFloat(rotation * 3.14159 / 180)
                sprite.position = CGPoint(x: (x + 0.5 - ((sqrt(2) / 2) * cos((rotation - 45) * 3.14159 / 180))) * Board.blockSize, y: -(y + 0.5 - ((sqrt(2) / 2) * sin((-rotation + 45) * 3.14159 / 180))) * Board.blockSize)
            }
        }
    }
}
