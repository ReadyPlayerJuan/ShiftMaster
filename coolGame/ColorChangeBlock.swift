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
    
    override func update(delta: TimeInterval) {
        super.update(delta: delta)
    }
    
    override func updateAttributes() {
        sprite.setValue(SKAttributeValue(float: Float(direction)), forAttribute: "a_direction")
    }
    
    override func gameActionFirstFrame(_ action: GameAction) {
        switch(action) {
        case .rotateLeft:
            super.gameActionFirstFrame(action)
            break
        case .rotateRight:
            super.gameActionFirstFrame(action)
            break
        default:
            break
        }
    }
    
    override func load() {
        sprite = SKSpriteNode.init(color: defaultSpriteColor, size: CGSize.init(width: Board.blockSize, height: Board.blockSize))
        sprite.shader = shader
        
        sprite.zPosition = zPos
        sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
    }
}
