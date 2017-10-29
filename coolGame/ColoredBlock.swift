//
//  ColoredBlock.swift
//  coolGame
//
//  Created by Nick Seel on 5/19/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class ColoredBlock: Entity {
    var colorIndex: Int = 0
    
    init(x: Int, y: Int, colorIndex: Int) {
        super.init()
        
        self.colorIndex = colorIndex
        self.x = Double(x)
        self.y = Double(y)
        
        isDynamic = false
        collisionType = colorIndex + 10
        collisionPriority = 99
        name = "colored block"
        hitboxType = HitboxType.block
        zPos = 1
        
        defaultSpriteColor = ColorTheme.getColor(colorIndex: colorIndex, colorVariation: true)
        shader = BlockShaders.defaultBlockShader
        
        load()
    }
    
    init(x: Int, y: Int, colorIndex: Int, invertVisible: Bool) {
        super.init()
        
        self.colorIndex = colorIndex
        self.x = Double(x)
        self.y = Double(y)
        self.invertExclusive = true
        self.invertVisible = invertVisible
        
        isDynamic = false
        collisionType = colorIndex + 10
        collisionPriority = 99
        name = "colored block"
        hitboxType = HitboxType.block
        zPos = 1
        
        defaultSpriteColor = ColorTheme.getColor(colorIndex: colorIndex, colorVariation: true)
        shader = BlockShaders.defaultBlockShader
        
        load()
    }
    
    override func update(delta: TimeInterval) {
        super.update(delta: delta)
    }
    
    override func updateAttributes() {
        
    }
    
    override func gameActionFirstFrame(_ action: GameAction) {
        super.gameActionFirstFrame(action)
    }
    
    override func load() {
        sprite = SKSpriteNode.init(color: defaultSpriteColor, size: CGSize.init(width: Board.blockSize, height: Board.blockSize))
        (sprite as! SKSpriteNode).shader = shader
        if(!GameState.shadersEnabledDebug) {
            (sprite as! SKSpriteNode).shader = nil
        }
        
        sprite.zPosition = zPos
        sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
    }
}
