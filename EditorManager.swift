//
//  EditorManager.swift
//  coolGame
//
//  Created by Nick Seel on 2/13/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class EditorManager {
    static var drawNode: SKNode!
    static var editorScene: EditorScene!
    
    
    /*menu sprite variables*/
    static let blockButtonSize = 0.75
    static let blockButtonBorder = 0.12
    static let blockWindowHeight = (blockButtonSize * 2) + (blockButtonBorder * 3)
    static let blockWindowWidth = (blockButtonSize * 6) + (blockButtonBorder * 7)
    
    static let numMenuButtons = 4
    static let menuButtonWidth = 3.6
    static let menuButtonHeight = 0.6
    static let menuButtonBorder = 0.12
    static let menuWindowHeight = (menuButtonHeight * Double(numMenuButtons)) + (menuButtonBorder * Double(numMenuButtons + 1))
    static let menuWindowWidth = (menuButtonWidth * 1) + (blockButtonBorder * 2)
    
    static var menuOpenSpeed = 2.0
    
    static var blockMenu: SKNode!
    static var blockMenuOpenButton: EditorMenuOpenButton!
    static var blockMenuButtons: [EditorBlockButton?] = []
    static var blockMenuOpenPct: Double = 0
    static var blockMenuOpening = false
    
    static var triangleMenu: SKNode!
    static var triangleMenuOpenButton: EditorMenuOpenButton!
    static var triangleMenuButtons: [EditorBlockButton?] = []
    static var triangleMenuOpenPct: Double = 0
    static var triangleMenuOpening = false
    
    static var mainMenu: SKNode!
    static var mainMenuOpenButton: EditorMenuOpenButton!
    static var mainMenuButtons: [EditorMainMenuButton?] = []
    static var mainMenuOpenPct: Double = 0
    static var mainMenuOpening = false
    
    
    /*editor control variables*/
    static var currentBlock: Entity? = nil
    static var currentBlockIcon: SKNode!
    static var canPlaceBlock = true
    
    static var singleTouchTimer = 0
    static var doubleTouchTimer = 0
    static var singleTouchStartPosition = CGPoint(x: -9999, y: -9999)
    static var doubleTouchStartPositions = [CGPoint(x: -9999, y: -9999), CGPoint(x: -9999, y: -9999)]
    
    static var doubleTouchStartAngle: CGFloat = 0.0
    static var prevAngle: CGFloat = 0.0
    
    static var prevSingleTouchTimer = 0
    static var prevDoubleTouchTimer = 0
    
    static let cameraSpeed = 3.5
    static let minCameraZoom = 0.15
    static let placeDragMinFrames = 8
    static let placeTapMaxFrames = placeDragMinFrames
    
    static var pressedButton = false
    static var prevPressedButton = false
    
    static var rotateProgress = 0.0
    
    static var camera = CGPoint(x: 0, y: 0)
    static var cameraVelocity = CGPoint(x: 0, y: 0)
    static var cameraZoom = 1.0
    static var cameraZoomVelocity = 0.0
    static var cameraRotation = 0.0
    static var rotationVelocity = 0.0
    
    class func update(delta: TimeInterval) {
        prevSingleTouchTimer = singleTouchTimer
        prevDoubleTouchTimer = doubleTouchTimer
        prevPressedButton = pressedButton
        
        if(InputController.currentTouches.count == 0) {
            canPlaceBlock = true
        }
        if(InputController.currentTouches.count == 1) {
            singleTouchTimer += 1
            
            if(singleTouchTimer == 1) {
                singleTouchStartPosition = CGPoint(x: InputController.currentTouches[0].x, y: InputController.currentTouches[0].y)
            }
        } else {
            singleTouchTimer = 0
            
            pressedButton = false
        }
        if(InputController.currentTouches.count == 2) {
            doubleTouchTimer += 1
            
            canPlaceBlock = false
            if(doubleTouchTimer == 1) {
                doubleTouchStartPositions = [CGPoint(x: InputController.currentTouches[0].x, y: InputController.currentTouches[0].y), CGPoint(x: InputController.currentTouches[1].x, y: InputController.currentTouches[1].y)]
            }
        } else {
            doubleTouchTimer = 0
            
            rotationVelocity -= cameraRotation / 60
        }
        
        
        let canPressButton = (!pressedButton && singleTouchTimer > 0) || (singleTouchTimer == 0 && prevSingleTouchTimer > 0 && doubleTouchTimer == 0)
        updateMainMenu(delta: delta, press: canPressButton)
        updateBlockMenu(delta: delta, press: canPressButton)
        updateTriangleMenu(delta: delta, press: canPressButton)
        
        if(singleTouchTimer == 0 && doubleTouchTimer == 0 && prevSingleTouchTimer > 0 && prevSingleTouchTimer < placeTapMaxFrames) {
            //place one block
            if(currentBlock != nil && canPlaceBlock && !pressedButton && !prevPressedButton) {
                drawBlock(touch: InputController.prevTouches[0])
            }
        } else if(singleTouchTimer >= placeDragMinFrames) {
            //place many blocks
            if(currentBlock != nil && canPlaceBlock && !pressedButton && !prevPressedButton) {
                let dx = InputController.currentTouches[0].x - InputController.prevTouches[0].x
                let dy = InputController.currentTouches[0].y - InputController.prevTouches[0].y
                let distance = max(1, ceil(hypot(dx, dy) / CGFloat(Board.blockSize)) * 2)
                
                for i in 0...Int(distance)-1 {
                    let point = CGPoint(x: InputController.prevTouches[0].x + (dx * (CGFloat(i) / distance)), y: InputController.prevTouches[0].y + (dy * (CGFloat(i) / distance)))
                    drawBlock(touch: point)
                }
            }
        } else if(doubleTouchTimer > 1) {
            //pan camera
            let movementX = ((InputController.currentTouches[0].x + InputController.currentTouches[1].x) / 2) - ((InputController.prevTouches[0].x + InputController.prevTouches[1].x) / 2)
            let movementY = ((InputController.currentTouches[0].y + InputController.currentTouches[1].y) / 2) - ((InputController.prevTouches[0].y + InputController.prevTouches[1].y) / 2)
            
            cameraVelocity.x -= CGFloat(Double(movementX) / Board.blockSize / delta / 1000 * cameraSpeed / cameraZoom)
            cameraVelocity.y += CGFloat(Double(movementY) / Board.blockSize / delta / 1000 * cameraSpeed / cameraZoom)
            
            
            //zoom camera
            let distance = hypot(InputController.currentTouches[0].x - InputController.currentTouches[1].x, InputController.currentTouches[0].y - InputController.currentTouches[1].y) - hypot(InputController.prevTouches[0].x - InputController.prevTouches[1].x, InputController.prevTouches[0].y - InputController.prevTouches[1].y)
            var modifier = min(1, cameraZoom)
            if(distance < 0) {
                modifier = min(1, cameraZoom - minCameraZoom)
            }
            cameraZoomVelocity += Double(distance) * cameraSpeed * modifier / 3200
            if(cameraZoom + cameraZoomVelocity < minCameraZoom) {
                cameraZoomVelocity = (minCameraZoom - cameraZoom) / 3
            }
            
            
            //rotate camera
            var currentAngle = atan((InputController.currentTouches[1].y - InputController.currentTouches[0].y) / (InputController.currentTouches[1].x - InputController.currentTouches[0].x + 0.0001))
            if(InputController.currentTouches[1].x > InputController.currentTouches[0].x && doubleTouchStartPositions[1].x < doubleTouchStartPositions[0].x ||
                    InputController.currentTouches[1].x < InputController.currentTouches[0].x && doubleTouchStartPositions[1].x > doubleTouchStartPositions[0].x) {
                currentAngle += 3.14159
            }
            if(currentAngle < 0) {
                currentAngle += 3.14159 * 2
            }
            if(doubleTouchTimer == 2) {
                doubleTouchStartAngle = currentAngle
                prevAngle = currentAngle
            }
            
            var angleDistance = currentAngle - prevAngle
            if(abs(angleDistance) > 3.14159) {
                if(abs((3.14159 * 2) - angleDistance) < abs(angleDistance)) {
                    angleDistance = (3.14159 * 2) - angleDistance
                    if(cameraRotation < 0) {
                        angleDistance *= -1
                    }
                }
                if(abs(angleDistance + (3.14159 * 2)) < abs(angleDistance)) {
                    angleDistance = angleDistance + (3.14159 * 2)
                }
            }
            rotationVelocity += Double(angleDistance) / 4
            
            prevAngle = currentAngle
            pressedButton = true
        }
        
        
        camera.x += cameraVelocity.x
        camera.y += cameraVelocity.y
        cameraZoom += cameraZoomVelocity
        cameraVelocity.x *= 0.8
        cameraVelocity.y *= 0.8
        cameraZoomVelocity *= 0.8
        
        if(cameraZoom < minCameraZoom) {
            cameraZoom = minCameraZoom
            cameraZoomVelocity = 0
        }
        
        cameraRotation += rotationVelocity
        rotationVelocity *= 0.8
        
        if(cameraRotation > (3.14159 / 4)) {
            GameState.gameAction(GameAction.rotateLeftInstant)
        }
        if(cameraRotation < -(3.14159 / 4)) {
            GameState.gameAction(GameAction.rotateRightInstant)
        }
        
        
        if(currentBlock != nil) {
            updateCurrentBlock()
        }
    }
    
    class func rotateLeft() {
        cameraRotation -= (3.14159 / 2)
        
        let newX = camera.y
        let newY = CGFloat(Board.boardHeight) - camera.x - 1
        camera = CGPoint(x: newX, y: newY)
    }
    
    class func rotateRight() {
        cameraRotation += (3.14159 / 2)
        
        let newX = CGFloat(Board.boardWidth) - camera.y - 1
        let newY = camera.x
        camera = CGPoint(x: newX, y: newY)
    }
    
    private class func updateMainMenu(delta: TimeInterval, press: Bool) {
        mainMenuOpenButton.update(active: press, delta: delta)
        if(mainMenuOpenButton.action && !pressedButton) {
            pressedButton = true
            
            if(mainMenuOpenPct != 1 && (!mainMenuOpening || mainMenuOpenPct == 0)) {
                mainMenuOpenPct += 0.01
                mainMenuOpening = true
            } else {
                mainMenuOpenPct -= 0.01
                mainMenuOpening = false
            }
        } else {
            if(mainMenuOpening && mainMenuOpenPct < 1) {
                mainMenuOpenPct += menuOpenSpeed * delta
                if(mainMenuOpenPct >= 1) {
                    mainMenuOpenPct = 1
                }
            } else if(!mainMenuOpening && mainMenuOpenPct > 0) {
                mainMenuOpenPct -= menuOpenSpeed * delta
                if(mainMenuOpenPct <= 0) {
                    mainMenuOpenPct = 0
                }
            }
        }
        
        mainMenu.position.x = (GameState.screenWidth / 2) - CGFloat(GameState.skewToEdges(pct: mainMenuOpenPct, power: 2) * (menuWindowWidth + blockButtonBorder) * Board.blockSize)
        mainMenuOpenButton.setHitboxPosition(x: Double(mainMenu.position.x) - ((blockWindowHeight / 4)) * Board.blockSize, y: Double(mainMenu.position.y) + (menuWindowHeight / -2) * Board.blockSize, width: blockWindowHeight * 0.5 * Board.blockSize, height: blockWindowHeight * Board.blockSize)
        
        for i in 0...numMenuButtons-1 {
            var x = 0.0
            var y = Double(i)
            x = (((x + 0.5) * menuButtonWidth) + ((x + 0.0) * menuButtonBorder) + ((menuWindowWidth - menuButtonWidth) / 2)) * Board.blockSize
            y = (((y + 0.5) * menuButtonHeight) + ((y + 1) * menuButtonBorder)) * -Board.blockSize
            
            if(mainMenuButtons[i] != nil) {
                mainMenuButtons[i]?.setHitboxPosition(x: Double(mainMenu.position.x) + x, y: Double(mainMenu.position.y) + y, width: menuButtonWidth * Board.blockSize, height: menuButtonHeight * Board.blockSize)
                mainMenuButtons[i]?.update(active: press, delta: delta)
                if((mainMenuButtons[i]?.action)! && !pressedButton) {
                    pressedButton = true
                    print(mainMenuButtons[i]!.text)
                }
            }
            
        }
    }
    
    private class func updateBlockMenu(delta: TimeInterval, press: Bool) {
        blockMenuOpenButton.update(active: press, delta: delta)
        if(blockMenuOpenButton.action && !pressedButton) {
            pressedButton = true
            
            if(blockMenuOpenPct != 1 && (!blockMenuOpening || blockMenuOpenPct == 0)) {
                blockMenuOpenPct += 0.01
                blockMenuOpening = true
            } else {
                blockMenuOpenPct -= 0.01
                blockMenuOpening = false
            }
        } else {
            if(blockMenuOpening && blockMenuOpenPct < 1) {
                blockMenuOpenPct += menuOpenSpeed * delta
                if(blockMenuOpenPct >= 1) {
                    blockMenuOpenPct = 1
                }
            } else if(!blockMenuOpening && blockMenuOpenPct > 0) {
                blockMenuOpenPct -= menuOpenSpeed * delta
                if(blockMenuOpenPct <= 0) {
                    blockMenuOpenPct = 0
                }
            }
        }
        
        blockMenu.position.x = (GameState.screenWidth / -2) + CGFloat(blockButtonBorder * Board.blockSize) - CGFloat(GameState.skewToEdges(pct: 1 - blockMenuOpenPct, power: 2) * (blockWindowWidth + blockButtonBorder) * Board.blockSize)
        blockMenuOpenButton.setHitboxPosition(x: Double(blockMenu.position.x) + (blockWindowWidth + (blockWindowHeight / 4)) * Board.blockSize, y: Double(blockMenu.position.y) + (blockWindowHeight / -2) * Board.blockSize, width: blockWindowHeight * 0.5 * Board.blockSize, height: blockWindowHeight * Board.blockSize)
        
        for i in 0...11 {
            var x = Double(i % 6)
            var y = Double(Int(i / 6))
            x = (((x + 0.5) * blockButtonSize) + ((x + 1) * blockButtonBorder)) * Board.blockSize
            y = (((y + 0.5) * blockButtonSize) + ((y + 1) * blockButtonBorder)) * -Board.blockSize
            
            if(blockMenuButtons[i] != nil) {
                blockMenuButtons[i]?.setHitboxPosition(x: Double(blockMenu.position.x) + x, y: Double(blockMenu.position.y) + y, width: blockButtonSize * Board.blockSize, height: blockButtonSize * Board.blockSize)
                blockMenuButtons[i]?.update(active: press, delta: delta)
                if((blockMenuButtons[i]?.action)! && !pressedButton) {
                    pressedButton = true
                    currentBlock = (blockMenuButtons[i]?.block)!
                }
            }
        }
    }
    
    private class func updateTriangleMenu(delta: TimeInterval, press: Bool) {
        triangleMenuOpenButton.update(active: press, delta: delta)
        if(triangleMenuOpenButton.action && !pressedButton) {
            pressedButton = true
            
            if(triangleMenuOpenPct != 1 && (!triangleMenuOpening || triangleMenuOpenPct == 0)) {
                triangleMenuOpenPct += 0.01
                triangleMenuOpening = true
            } else {
                triangleMenuOpenPct -= 0.01
                triangleMenuOpening = false
            }
        } else {
            if(triangleMenuOpening && triangleMenuOpenPct < 1) {
                triangleMenuOpenPct += menuOpenSpeed * delta
                if(triangleMenuOpenPct >= 1) {
                    triangleMenuOpenPct = 1
                }
            } else if(!triangleMenuOpening && triangleMenuOpenPct > 0) {
                triangleMenuOpenPct -= menuOpenSpeed * delta
                if(triangleMenuOpenPct <= 0) {
                    triangleMenuOpenPct = 0
                }
            }
        }
        
        triangleMenu.position.x = (GameState.screenWidth / -2) + CGFloat(blockButtonBorder * Board.blockSize) - CGFloat(GameState.skewToEdges(pct: 1 - triangleMenuOpenPct, power: 2) * (blockWindowWidth + blockButtonBorder) * Board.blockSize)
        triangleMenuOpenButton.setHitboxPosition(x: Double(triangleMenu.position.x) + (blockWindowWidth + (blockWindowHeight / 4)) * Board.blockSize, y: Double(triangleMenu.position.y) + (blockWindowHeight / -2) * Board.blockSize, width: blockWindowHeight * 0.5 * Board.blockSize, height: blockWindowHeight * Board.blockSize)
        
        for i in 0...11 {
            var x = Double(i % 6)
            var y = Double(Int(i / 6))
            x = (((x + 0.5) * blockButtonSize) + ((x + 1) * blockButtonBorder)) * Board.blockSize
            y = (((y + 0.5) * blockButtonSize) + ((y + 1) * blockButtonBorder)) * -Board.blockSize
            
            if(triangleMenuButtons[i] != nil) {
                triangleMenuButtons[i]?.setHitboxPosition(x: Double(triangleMenu.position.x) + x, y: Double(triangleMenu.position.y) + y, width: blockButtonSize * Board.blockSize, height: blockButtonSize * Board.blockSize)
                triangleMenuButtons[i]?.update(active: press, delta: delta)
                if((triangleMenuButtons[i]?.action)! && !pressedButton) {
                    pressedButton = true
                    currentBlock = (triangleMenuButtons[i]?.block)!
                }
            }
        }
    }
    
    class func updateCurrentBlock() {
        currentBlockIcon.removeAllChildren()
        
        if(currentBlock != nil) {
            let sprite = (currentBlock?.sprite.copy() as! SKSpriteNode)
            sprite.zPosition = -1
            sprite.zRotation = CGFloat(Board.direction) * (3.14159 / 2)
            sprite.alpha = (currentBlock?.sprite.alpha)!
            
            let border = SKShapeNode.init(rect: CGRect.init(x: (Board.blockSize / -2), y: (Board.blockSize / -2), width: Board.blockSize, height: Board.blockSize))
            border.strokeColor = UIColor.init(white: 0.4, alpha: 1.0)
            border.fillColor = UIColor.clear
            border.lineWidth = 2
            border.zPosition = 2
            
            border.xScale = sprite.xScale
            border.yScale = sprite.yScale
            sprite.xScale = 1
            sprite.yScale = 1
            
            currentBlockIcon.addChild(border)
            border.addChild(sprite)
        }
    }
    
    class func drawBlock(touch: CGPoint) {
        let distanceToCenter = hypot(touch.x, touch.y)
        var angle = atan(touch.y / (touch.x + 0.0001))
        if(touch.x < 0) {
            angle += 3.14159
        }
        if(angle < 0) {
            angle += 3.14159 * 2
        }
        
        angle -= CGFloat(cameraRotation)
        let position = CGPoint(x: distanceToCenter * cos(angle), y: distanceToCenter * sin(angle))
        
        let blockPositionX = (floor((Double(position.x) / Board.blockSize / cameraZoom) + Double(camera.x) + 0.5))
        let blockPositionY = -((floor((Double(position.y) / Board.blockSize / cameraZoom) - Double(camera.y) + 0.5)))
        
        
        var overlappingEntities: [Entity] = []
        for entity in EntityManager.entities {
            if(entity.x == blockPositionX && entity.y == blockPositionY) {
                overlappingEntities.append(entity)
            }
        }
        
        var canPlace = true
        switch(currentBlock!.name) {
        case "solid block":
            for entity in overlappingEntities {
                if(entity.name == "solid block" || entity.name == "nonsolid block" || entity.name == "colored block" || entity.name == "hazard block") {
                    EntityManager.removeEntity(entity: entity)
                }
            }
            
            EntityManager.addEntity(entity: SolidBlock.init(x: Int(blockPositionX), y: Int(blockPositionY)))
            break
        case "nonsolid block":
            for entity in overlappingEntities {
                if(entity.name == "solid block" || entity.name == "nonsolid block" || entity.name == "colored block" || entity.name == "hazard block") {
                    EntityManager.removeEntity(entity: entity)
                }
            }
            
            EntityManager.addEntity(entity: NonsolidBlock.init(x: Int(blockPositionX), y: Int(blockPositionY)))
            break
        case "colored block":
            for entity in overlappingEntities {
                if(entity.name == "solid block" || entity.name == "nonsolid block" || entity.name == "colored block" || entity.name == "hazard block") {
                    EntityManager.removeEntity(entity: entity)
                }
            }
            
            EntityManager.addEntity(entity: ColoredBlock.init(x: Int(blockPositionX), y: Int(blockPositionY), colorIndex: (currentBlock as! ColoredBlock).colorIndex))
            break
        case "hazard block":
            for entity in overlappingEntities {
                if(entity.name == "solid block" || entity.name == "nonsolid block" || entity.name == "colored block" || entity.name == "hazard block") {
                    EntityManager.removeEntity(entity: entity)
                }
            }
            
            EntityManager.addEntity(entity: NonsolidBlock.init(x: Int(blockPositionX), y: Int(blockPositionY)))
            EntityManager.addEntity(entity: HazardBlock.init(x: Int(blockPositionX), y: Int(blockPositionY)))
            break
        case "color change block":
            if(overlappingEntities.count == 0) {
                canPlace = false
            }
            for entity in overlappingEntities {
                if(entity.name == "solid block" || entity.name == "hazard block") {
                    canPlace = false
                }
            }
            if(canPlace) {
                for entity in overlappingEntities {
                    if(entity.name == "color change block" || entity.name == "exit block" || entity.name == "invert block") {
                        EntityManager.removeEntity(entity: entity)
                    }
                }
                
                EntityManager.addEntity(entity: ColorChangeBlock.init(x: Int(blockPositionX), y: Int(blockPositionY), colorIndex: (currentBlock as! ColorChangeBlock).colorIndex, direction: Board.direction))
            }
            break
        case "exit block":
            if(overlappingEntities.count == 0) {
                canPlace = false
            }
            for entity in overlappingEntities {
                if(entity.name == "solid block" || entity.name == "hazard block") {
                    canPlace = false
                }
            }
            if(canPlace) {
                for entity in overlappingEntities {
                    if(entity.name == "color change block" || entity.name == "exit block" || entity.name == "invert block") {
                        EntityManager.removeEntity(entity: entity)
                    }
                }
                
                EntityManager.addEntity(entity: ExitBlock.init(x: Int(blockPositionX), y: Int(blockPositionY), direction: Board.direction))
            }
            break
        case "invert block":
            if(overlappingEntities.count == 0) {
                canPlace = false
            }
            for entity in overlappingEntities {
                if(entity.name == "solid block" || entity.name == "hazard block") {
                    canPlace = false
                }
            }
            if(canPlace) {
                for entity in overlappingEntities {
                    if(entity.name == "color change block" || entity.name == "exit block" || entity.name == "invert block") {
                        EntityManager.removeEntity(entity: entity)
                    }
                }
                
                EntityManager.addEntity(entity: InvertBlock.init(x: Int(blockPositionX), y: Int(blockPositionY), direction: Board.direction))
            }
            break
        default:
            break
        }
        
        Board.loadHazardBlockData()
        EntityManager.updateEntityAttributes()
        EntityManager.redrawEntities(node: GameState.drawNode, name: "all")
    }
    
    class func initElements() {
        drawNode.removeAllChildren()
        
        blockMenu = SKNode.init()
        blockMenu.zPosition = 10
        blockMenu.position = CGPoint(x: (GameState.screenWidth / -2) + CGFloat(blockButtonBorder * Board.blockSize), y: (GameState.screenHeight / 2) - CGFloat(blockButtonBorder * Board.blockSize))
        
        let blockBox = SKShapeNode.init(rect: CGRect.init(x: (blockWindowWidth * 0) * Board.blockSize, y: (blockWindowHeight / -1) * Board.blockSize, width: blockWindowWidth * Board.blockSize, height: blockWindowHeight * Board.blockSize), cornerRadius: 0)
        //blockBox.
        blockBox.strokeColor = UIColor.init(white: 0.4, alpha: 1.0)
        blockBox.lineWidth = 3
        blockBox.fillColor = UIColor.black
        blockBox.zPosition = 1
        blockMenu.addChild(blockBox)
        drawNode.addChild(blockMenu)
        
        blockMenuOpenButton = EditorMenuOpenButton.init(x: blockWindowWidth * Board.blockSize, y: (blockWindowHeight / -2) * Board.blockSize, height: blockWindowHeight * Board.blockSize)
        blockMenuOpenButton.setHitboxPosition(x: Double(blockMenu.position.x) + blockWindowWidth * Board.blockSize, y: Double(blockMenu.position.y) + (blockWindowHeight / -2) * Board.blockSize, width: blockWindowHeight * Board.blockSize, height: blockWindowHeight * Board.blockSize)
        blockMenu.addChild(blockMenuOpenButton.sprite)
        
        let blockMenuLabel = SKLabelNode.init(text: "BLOCKS")
        blockMenuLabel.fontName = "Menlo-BoldItalic"
        blockMenuLabel.fontColor = UIColor.init(white: 0.9, alpha: 1.0)
        blockMenuLabel.fontSize = CGFloat(floor(blockButtonSize * Board.blockSize * 0.42))
        blockMenuLabel.position.x += CGFloat(blockButtonSize * Board.blockSize * 0.53)
        blockMenuLabel.zRotation = CGFloat(3.14159 / 2)
        blockMenuLabel.zPosition = 4
        blockMenuOpenButton.sprite.addChild(blockMenuLabel)
        
        blockMenuButtons = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        
        for i in 0...11 {
            var x = Double(i % 6)
            var y = Double(Int(i / 6))
            x = (((x + 0.5) * blockButtonSize) + ((x + 1) * blockButtonBorder)) * Board.blockSize
            y = (((y + 0.5) * blockButtonSize) + ((y + 1) * blockButtonBorder)) * -Board.blockSize
            switch(i) {
            case 0:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: SolidBlock.init(x: 0, y: 0)); break
            case 1:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: NonsolidBlock.init(x: 0, y: 0)); break
            case 4:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: HazardBlock.init(x: 0, y: 0)); break
            case 6:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColoredBlock.init(x: 0, y: 0, colorIndex: 0)); break
            case 7:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColoredBlock.init(x: 0, y: 0, colorIndex: 1)); break
            case 8:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColoredBlock.init(x: 0, y: 0, colorIndex: 2)); break
            case 9:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColoredBlock.init(x: 0, y: 0, colorIndex: 3)); break
            case 10:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColoredBlock.init(x: 0, y: 0, colorIndex: 4)); break
            case 11:
                blockMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColoredBlock.init(x: 0, y: 0, colorIndex: 5)); break
            default:
                break
            }
            
            if(blockMenuButtons[i] != nil) {
                blockMenuButtons[i]?.setHitboxPosition(x: Double(blockMenu.position.x) + x, y: Double(blockMenu.position.y) + y, width: blockButtonSize * Board.blockSize, height: blockButtonSize * Board.blockSize)
                blockBox.addChild((blockMenuButtons[i]?.sprite)!)
            }
        }
        
        
        
        triangleMenu = SKNode.init()
        triangleMenu.zPosition = 10
        triangleMenu.position = CGPoint(x: (GameState.screenWidth / -2) + CGFloat(blockButtonBorder * Board.blockSize), y: (GameState.screenHeight / 2) - CGFloat(((blockButtonBorder * 2) + blockWindowHeight) * Board.blockSize))
        
        let triangleBox = SKShapeNode.init(rect: CGRect.init(x: (blockWindowWidth * 0) * Board.blockSize, y: (blockWindowHeight / -1) * Board.blockSize, width: blockWindowWidth * Board.blockSize, height: blockWindowHeight * Board.blockSize), cornerRadius: 0)
        triangleBox.strokeColor = UIColor.init(white: 0.4, alpha: 1.0)
        triangleBox.lineWidth = 3
        triangleBox.fillColor = UIColor.black
        triangleBox.zPosition = 1
        triangleMenu.addChild(triangleBox)
        drawNode.addChild(triangleMenu)
        
        triangleMenuOpenButton = EditorMenuOpenButton.init(x: blockWindowWidth * Board.blockSize, y: (blockWindowHeight / -2) * Board.blockSize, height: blockWindowHeight * Board.blockSize)
        triangleMenuOpenButton.setHitboxPosition(x: Double(triangleMenu.position.x) + blockWindowWidth * Board.blockSize, y: Double(triangleMenu.position.y) + (blockWindowHeight / -2) * Board.blockSize, width: blockWindowHeight * Board.blockSize, height: blockWindowHeight * Board.blockSize)
        triangleMenu.addChild(triangleMenuOpenButton.sprite)
        
        let triangleMenuLabel = SKLabelNode.init(text: "TRIANGLES")
        triangleMenuLabel.fontName = "Menlo-BoldItalic"
        triangleMenuLabel.fontColor = UIColor.init(white: 0.9, alpha: 1.0)
        triangleMenuLabel.fontSize = CGFloat(floor(blockButtonSize * Board.blockSize * 0.42))
        triangleMenuLabel.position.x += CGFloat(blockButtonSize * Board.blockSize * 0.53)
        triangleMenuLabel.zRotation = CGFloat(3.14159 / 2)
        triangleMenuLabel.zPosition = 4
        triangleMenuOpenButton.sprite.addChild(triangleMenuLabel)
        
        triangleMenuButtons = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        
        for i in 0...11 {
            var x = Double(i % 6)
            var y = Double(Int(i / 6))
            x = (((x + 0.5) * blockButtonSize) + ((x + 1) * blockButtonBorder)) * Board.blockSize
            y = (((y + 0.5) * blockButtonSize) + ((y + 1) * blockButtonBorder)) * -Board.blockSize
            switch(i) {
            case 0:
                triangleMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ExitBlock.init(x: 0, y: 0, direction: 0)); break
            case 1:
                triangleMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: InvertBlock.init(x: 0, y: 0, direction: 0)); break
            case 6:
                triangleMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColorChangeBlock.init(x: 0, y: 0, colorIndex: 0, direction: 0)); break
            case 7:
                triangleMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColorChangeBlock.init(x: 0, y: 0, colorIndex: 1, direction: 0)); break
            case 8:
                triangleMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColorChangeBlock.init(x: 0, y: 0, colorIndex: 2, direction: 0)); break
            case 9:
                triangleMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColorChangeBlock.init(x: 0, y: 0, colorIndex: 3, direction: 0)); break
            case 10:
                triangleMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColorChangeBlock.init(x: 0, y: 0, colorIndex: 4, direction: 0)); break
            case 11:
                triangleMenuButtons[i] = EditorBlockButton.init(x: x, y: y, size: blockButtonSize, block: ColorChangeBlock.init(x: 0, y: 0, colorIndex: 5, direction: 0)); break
            default:
                break
            }
            
            if(triangleMenuButtons[i] != nil) {
                triangleMenuButtons[i]?.setHitboxPosition(x: Double(triangleMenu.position.x) + x, y: Double(triangleMenu.position.y) + y, width: blockButtonSize * Board.blockSize, height: blockButtonSize * Board.blockSize)
                triangleBox.addChild((triangleMenuButtons[i]?.sprite)!)
            }
        }
        
        
        
        mainMenu = SKNode.init()
        mainMenu.zPosition = 20
        mainMenu.position = CGPoint(x: (GameState.screenWidth / 2) - CGFloat(menuButtonBorder * Board.blockSize), y: (GameState.screenHeight / 2) - CGFloat(menuButtonBorder * Board.blockSize))
        
        let menuBox = SKShapeNode.init(rect: CGRect.init(x: (menuWindowWidth * 0) * Board.blockSize, y: (menuWindowHeight / -1) * Board.blockSize, width: menuWindowWidth * Board.blockSize, height: menuWindowHeight * Board.blockSize), cornerRadius: 0)
        menuBox.strokeColor = UIColor.init(white: 0.4, alpha: 1.0)
        menuBox.lineWidth = 3
        menuBox.fillColor = UIColor.black
        menuBox.zPosition = 1
        mainMenu.addChild(menuBox)
        drawNode.addChild(mainMenu)
        
        mainMenuOpenButton = EditorMenuOpenButton.init(x: 0, y: (menuWindowHeight / -2) * Board.blockSize, height: menuWindowHeight * Board.blockSize, width: blockWindowHeight * 0.6 * Board.blockSize)
        mainMenuOpenButton.setHitboxPosition(x: Double(mainMenu.position.x) - menuWindowWidth * Board.blockSize, y: Double(mainMenu.position.y) + (menuWindowHeight / -2) * Board.blockSize, width: blockButtonSize * Board.blockSize, height: menuWindowHeight * Board.blockSize)
        mainMenu.addChild(mainMenuOpenButton.sprite)
        
        let mainMenuLabel = SKLabelNode.init(text: "MENU")
        mainMenuLabel.fontName = "Menlo-BoldItalic"
        mainMenuLabel.fontColor = UIColor.init(white: 0.9, alpha: 1.0)
        mainMenuLabel.fontSize = CGFloat(floor(blockButtonSize * Board.blockSize * 0.42))
        mainMenuLabel.position.x -= CGFloat(blockButtonSize * Board.blockSize * 0.53)
        mainMenuLabel.zRotation = CGFloat(3.14159 / -2)
        mainMenuLabel.zPosition = 4
        mainMenuOpenButton.sprite.addChild(mainMenuLabel)
        
        mainMenuButtons = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
        
        for i in 0...numMenuButtons-1 {
            var x = 0.0
            var y = Double(i)
            x = (((x + 0.5) * menuButtonWidth) + ((x + 0.0) * menuButtonBorder) + ((menuWindowWidth - menuButtonWidth) / 2)) * Board.blockSize
            y = (((y + 0.5) * menuButtonHeight) + ((y + 1) * menuButtonBorder)) * -Board.blockSize
            switch(i) {
            case 0:
                mainMenuButtons[i] = EditorMainMenuButton.init(x: x, y: y, width: menuButtonWidth * Board.blockSize, height: menuButtonHeight * Board.blockSize, text: "BUTTON1")
                break
            case 1:
                mainMenuButtons[i] = EditorMainMenuButton.init(x: x, y: y, width: menuButtonWidth * Board.blockSize, height: menuButtonHeight * Board.blockSize, text: "BUTTON2")
                break
            case 2:
                mainMenuButtons[i] = EditorMainMenuButton.init(x: x, y: y, width: menuButtonWidth * Board.blockSize, height: menuButtonHeight * Board.blockSize, text: "BUTTON3")
                break
            case 3:
                mainMenuButtons[i] = EditorMainMenuButton.init(x: x, y: y, width: menuButtonWidth * Board.blockSize, height: menuButtonHeight * Board.blockSize, text: "BUTTON4")
                break
            default:
                break
            }
            
            if(mainMenuButtons[i] != nil) {
                mainMenuButtons[i]?.setHitboxPosition(x: Double(mainMenu.position.x) + x, y: Double(mainMenu.position.y) + y, width: menuButtonWidth * Board.blockSize, height: menuButtonHeight * Board.blockSize)
                menuBox.addChild((mainMenuButtons[i]?.sprite)!)
            }
        }
        
        
        
        let currentBlockSize = 1.0
        let cornerSize = 0.1
        currentBlockIcon = SKShapeNode.init(rect: CGRect(x: (Board.blockSize * currentBlockSize) / -2, y: (Board.blockSize * currentBlockSize) / -2, width: Board.blockSize * currentBlockSize, height: Board.blockSize * currentBlockSize), cornerRadius: CGFloat(Board.blockSize * currentBlockSize * cornerSize))
        currentBlockIcon.position = CGPoint(x: (GameState.screenWidth / 2) - CGFloat(Board.blockSize * ((currentBlockSize / 2) + blockButtonBorder)), y: (GameState.screenHeight / -2) + CGFloat(Board.blockSize * ((currentBlockSize / 2) + blockButtonBorder)))
        (currentBlockIcon as! SKShapeNode).fillColor = UIColor.black
        (currentBlockIcon as! SKShapeNode).strokeColor = UIColor.init(white: 0.4, alpha: 1.0)
        (currentBlockIcon as! SKShapeNode).lineWidth = 3
        currentBlockIcon.zPosition = 0
        
        drawNode.addChild(currentBlockIcon)
    }
    
    class func loadColor(colorIndex: Int) -> UIColor {
        if(colorIndex == -3) {
            return Board.backgroundColor
        } else if(colorIndex == -2) {
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else if(colorIndex == -1) {
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else if(colorIndex >= 0 && colorIndex <= 5) {
            var colorArray = ColorTheme.colors[Board.colorTheme][colorIndex]
            
            return UIColor(red: CGFloat(colorArray[0]) / 255.0, green: CGFloat(colorArray[1]) / 255.0, blue: CGFloat(colorArray[2]) / 255.0, alpha: 1.0)
        } else {
            return UIColor.clear
        }
    }
    /*
    class func addLeftRow() {
        for i in 0...(Board.blocks.count - 1) {
            Board.blocks[i].insert(Block.init(blockType: 5, color: -1, secondaryColor: -1, dir: -1, x: 0, y: Double(i)), at: 0)
            for j in 1...Board.blocks[i].count-1 {
                Board.blocks[i][j]?.x += 1.0
                if(Board.blocks[i][j]?.type == 6) {
                    Board.blocks[i][j]?.colorProgressionBase += 1
                }
            }
        }
        Board.spawnPoint.x += 1
        EntityManager.getPlayer()!.x += 1
        for e in Board.otherEntities {
            e.x += 1
        }
        EntityManager.reloadAllEntities()
    }
    
    class func trimLeftRow() {
        for i in 0...Board.blocks.count-1 {
            Board.blocks[i].remove(at: 0)
            for j in 0...Board.blocks[i].count-1 {
                Board.blocks[i][j]?.x -= 1.0
            }
        }
        Board.spawnPoint.x -= 1
        EntityManager.getPlayer()!.x -= 1
        for e in Board.otherEntities {
            e.x -= 1
        }
        EntityManager.reloadAllEntities()
    }
    
    class func addRightRow() {
        for i in 0...(Board.blocks.count - 1) {
            Board.blocks[i].append(Block.init(blockType: 5, color: -1, secondaryColor: -1, dir: -1, x: Double(Board.blocks[i].count), y: Double(i)))
        }
    }
    
    class func trimRightRow() {
        for i in 0...(Board.blocks.count - 1) {
            Board.blocks[i].remove(at: Board.blocks[i].count-1)
        }
    }
    
    class func addTopRow() {
        Board.blocks.insert([Block](), at: 0)
        for _ in 0...Board.blocks[1].count-1 {
            Board.blocks[0].append(Block.init(blockType: 5, color: -1, secondaryColor: -1, dir: -1, x: 0, y: 0))
        }
        for row in 0...Board.blocks.count-1 {
            for col in 0...Board.blocks[0].count-1 {
                Board.blocks[row][col]?.y = Double(row)
                Board.blocks[row][col]?.x = Double(col)
            }
        }
        Board.spawnPoint.y += 1
        EntityManager.getPlayer()!.y += 1
        for e in Board.otherEntities {
            e.y += 1
        }
        EntityManager.reloadAllEntities()
    }
    
    class func trimTopRow() {
        Board.blocks.remove(at: 0)
        for row in 0...Board.blocks.count-1 {
            for col in 0...Board.blocks[0].count-1 {
                Board.blocks[row][col]?.y = Double(row)
                Board.blocks[row][col]?.x = Double(col)
            }
        }
        Board.spawnPoint.y -= 1
        EntityManager.getPlayer()!.y -= 1
        for e in Board.otherEntities {
            e.y -= 1
        }
        EntityManager.reloadAllEntities()
    }
    
    class func addBottomRow() {
        Board.blocks.append([Block]())
        for i in 0...(Board.blocks[1].count - 1) {
            Board.blocks[Board.blocks.count-1].append(Block.init(blockType: 5, color: -1, secondaryColor: -1, dir: -1, x: Double(i), y: Double(Board.blocks.count-1)))
        }
    }
    
    class func trimBottomRow() {
        Board.blocks.remove(at: Board.blocks.count-1)
    }
    
    class func trim() {
        var trimmable: Bool
        
        trimmable = true
        while(trimmable) {
            trimmable = true
            for row in 0...Board.blocks.count-1 {
                if(Board.blocks[row][0]?.type != 5) {
                    trimmable = false
                }
            }
            if(trimmable) {
                trimLeftRow()
                camera.x -= 1
            }
        }
        
        trimmable = true
        while(trimmable) {
            trimmable = true
            for row in 0...Board.blocks.count-1 {
                if(Board.blocks[row][Board.blocks[0].count-1]?.type != 5) {
                    trimmable = false
                }
            }
            if(trimmable) {
                trimRightRow()
            }
        }
        
        trimmable = true
        while(trimmable) {
            trimmable = true
            for col in 0...Board.blocks[0].count-1 {
                if(Board.blocks[0][col]?.type != 5) {
                    trimmable = false
                }
            }
            if(trimmable) {
                trimTopRow()
                camera.y -= 1
            }
        }
        
        trimmable = true
        while(trimmable) {
            trimmable = true
            for col in 0...Board.blocks[0].count-1 {
                if(Board.blocks[Board.blocks.count-1][col]?.type != 5) {
                    trimmable = false
                }
            }
            if(trimmable) {
                trimBottomRow()
            }
        }
        /*
        addLeftRow()
        addRightRow()
        addTopRow()
        addBottomRow()
        */
        completeRedraw()
    }*/
    
    class func encodeStageEdit() -> String {
        /*trim()
        
        var code = ""
        var exits = [[Int]]()
        
        code += "b"
        for row in 0...Board.blocks.count-1 {
            for col in 0...Board.blocks[0].count-1 {
                let b = Board.blocks[row][col]!
                
                switch(b.type) {
                case 0:
                    code += "0"; break
                case 1:
                    code += "1"; break
                case 2:
                    code += "\(b.colorIndex + 2)"; break
                case 3:
                    var d = b.direction-Board.direction + 8
                    d %= 4
                    code += "\(d)\(b.colorIndex+2)\(b.colorIndex2+2)"; break
                case 4:
                    var d = b.direction+1-Board.direction + 8
                    d %= 4
                    code += "-\(d)\(b.colorIndex+2)"
                    exits.append([col, row, 0]); break
                case 5:
                    code += "-9"; break
                case 6:
                    code += "99"; break
                case 7:
                    var d = b.direction-Board.direction + 8
                    d %= 4
                    code += "\(d)\(b.colorIndex+2)\(9)"; break
                case 8:
                    var d = b.direction-Board.direction + 8
                    d %= 4
                    code += "\(d+4)\(b.colorIndex+2)\(b.colorIndex2+2)"; break
                case 9:
                    var d = b.direction-Board.direction + 8
                    d %= 4
                    code += "-\(d+5)0"; break
                default:
                    break
                }
                
                if(col != Board.blocks[0].count-1) {
                    code += "."
                }
            }
            
            if(row != Board.blocks.count-1) {
                code += ","
            }
        }
        code += "e"
        
        code += "s"
        code += "\(Int(EntityManager.getPlayer()!.x))"
        code += "."
        code += "\(Int(EntityManager.getPlayer()!.y))"
        code += "e"
        
        code += "x"
        if(exits.count == 0) {
            code += "0.0.0"
        } else {
            for i in 0...exits.count-1 {
                let e = exits[i]
                code += "\(e[0])"
                code += "."
                code += "\(e[1])"
                code += "."
                code += "\(e[2])"
                
                if(i != exits.count-1) {
                    code += ","
                }
            }
        }
        code += "e"
        
        for e in Board.otherEntities {
            code += "n"
            
            if(e.name == "moving block") {
                code += "0"
                code += "\((e as! MovingBlock).colorIndex)"
                code += "."
                code += "\((e as! MovingBlock).direction)"
                code += "."
                code += "\(Int(e.x))"
                code += "."
                code += "\(Int(e.y))"
                code += "e"
            } else {
                
            }
        }
        
        code += "m"
        code += "defaultName"
        
        return code*/
        return ""
    }
}
