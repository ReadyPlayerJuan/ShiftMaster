//
//  ExitBlock.swift
//  coolGame
//
//  Created by Nick Seel on 6/3/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class ExitBlock: Entity {
    var direction: Int = 0
    var disabled: Bool = false
    
    init(x: Int, y: Int, direction: Int) {
        super.init()
        
        self.x = Double(x)
        self.y = Double(y)
        self.direction = direction
        
        isDynamic = false
        collisionType = -1
        collisionPriority = 99
        name = "exit block"
        hitboxType = HitboxType.block
        zPos = 3
        
        defaultSpriteColor = ColorTheme.getGrayscaleColor(black: false, colorVariation: false)
        shader = BlockShaders.triangleBlockShader
        
        load()
    }
    
    init(x: Int, y: Int, direction: Int, invertVisible: Bool) {
        super.init()
        
        self.x = Double(x)
        self.y = Double(y)
        self.direction = direction
        self.invertExclusive = true
        self.invertVisible = invertVisible
        
        isDynamic = false
        collisionType = -1
        collisionPriority = 99
        name = "exit block"
        hitboxType = HitboxType.block
        zPos = 3
        
        defaultSpriteColor = ColorTheme.getGrayscaleColor(black: false, colorVariation: false)
        shader = BlockShaders.triangleBlockShader
        
        load()
    }
    
    func disable() {
        disabled = true
    }
    
    override func update(delta: TimeInterval) {
        //super.update(delta: delta)
    }
    
    override func updateAttributes() {
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: Float(direction)), forAttribute: "a_direction")
        
        if(!disabled) {
            let cycle = 1.0
            var b = GameState.time
            
            let a = Double(Int(b/cycle))*cycle
            let c = b - a
            b = c
            
            b /= cycle
            b *= 2
            b = b - 1
            b = pow(abs(b), 1.0)
            
            sprite.alpha = CGFloat(b)
        } else {
            sprite.alpha = 0
        }
    }
    
    override func gameActionFirstFrame(_ action: GameAction) {
        super.gameActionFirstFrame(action)
    }
    
    override func load() {
        
        print("loaded exit")
        sprite = SKSpriteNode.init(color: defaultSpriteColor, size: CGSize.init(width: Board.blockSize, height: Board.blockSize))
        (sprite as! SKSpriteNode).shader = shader
        if(!GameState.shadersEnabledDebug) {
            (sprite as! SKSpriteNode).shader = nil
        }
        
        sprite.zPosition = zPos
        sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
    }
}
