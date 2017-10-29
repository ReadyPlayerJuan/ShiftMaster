//
//  ColorChangeBlock.swift
//  coolGame
//
//  Created by Nick Seel on 6/2/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class ColorChangeBlock: Entity {
    var colorIndex: Int = 0
    var direction: Int = 0
    
    init(x: Int, y: Int, colorIndex: Int, direction: Int) {
        super.init()
        
        self.colorIndex = colorIndex
        self.x = Double(x)
        self.y = Double(y)
        self.direction = direction
        
        isDynamic = false
        collisionType = -1
        collisionPriority = 99
        name = "color change block"
        hitboxType = HitboxType.block
        zPos = 3
        
        defaultSpriteColor = ColorTheme.getColor(colorIndex: colorIndex, colorVariation: false)
        shader = BlockShaders.triangleBlockShader
        
        load()
    }
    
    init(x: Int, y: Int, colorIndex: Int, direction: Int, invertVisible: Bool) {
        super.init()
        
        self.colorIndex = colorIndex
        self.x = Double(x)
        self.y = Double(y)
        self.direction = direction
        self.invertExclusive = true
        self.invertVisible = invertVisible
        
        isDynamic = false
        collisionType = -1
        collisionPriority = 99
        name = "color change block"
        hitboxType = HitboxType.block
        zPos = 3
        
        defaultSpriteColor = ColorTheme.getColor(colorIndex: colorIndex, colorVariation: false)
        shader = BlockShaders.triangleBlockShader
        
        load()
    }
    
    override func update(delta: TimeInterval) {
        super.update(delta: delta)
    }
    
    override func updateAttributes() {
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: Float(direction)), forAttribute: "a_direction")
    }
    
    override func gameActionFirstFrame(_ action: GameAction) {
        super.gameActionFirstFrame(action)
    }
    
    override func load() {
        /*let path = UIBezierPath.init()
        path.move(to: CGPoint(x: Board.blockSize / -2, y: Board.blockSize / -2))
        path.addLine(to: CGPoint(x: Board.blockSize / 2, y: Board.blockSize / -2))
        path.addLine(to: CGPoint(x: 0, y: Board.blockSize * (-0.5 + (sqrt(3.0) / 2.0))))
        
        sprite = SKShapeNode.init(path: path.cgPath)
        (sprite as! SKShapeNode).fillColor = UIColor.red
        (sprite as! SKShapeNode).strokeColor = UIColor.clear*/
        sprite = SKSpriteNode.init(color: defaultSpriteColor, size: CGSize.init(width: Board.blockSize, height: Board.blockSize))
        (sprite as! SKSpriteNode).shader = shader
        if(!GameState.shadersEnabledDebug) {
            (sprite as! SKSpriteNode).shader = nil
        }
        
        sprite.zPosition = zPos
        sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
    }
}
