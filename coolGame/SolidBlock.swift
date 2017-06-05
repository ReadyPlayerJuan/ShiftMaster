//
//  SolidBlock.swift
//  coolGame
//
//  Created by Nick Seel on 5/19/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class SolidBlock: Entity {
    init(x: Int, y: Int) {
        super.init()
        
        self.x = Double(x)
        self.y = Double(y)
        
        isDynamic = false
        collisionType = 0
        collisionPriority = 99
        name = "solid block"
        hitboxType = HitboxType.block
        zPos = 1
        
        
        defaultSpriteColor = ColorTheme.getGrayscaleColor(black: false, colorVariation: true)
        shader = BlockShaders.defaultBlockShader
        
        load()
    }
    
    override func update(delta: TimeInterval) {
        super.update(delta: delta)
    }
    
    override func updateAttributes() {
        
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
