//
//  HazardBlock.swift
//  coolGame
//
//  Created by Nick Seel on 6/3/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class HazardBlock: Entity {
    let edgeSize = 0.0
    
    var colorProgressionBase: Double = 0
    let hazardCycle: Double = 15.0
    
    var extendL = false
    var extendR = false
    var extendT = false
    var extendB = false
    var extendTL = false
    var extendTR = false
    var extendBL = false
    var extendBR = false
    
    init(x: Int, y: Int) {
        super.init()
        
        self.x = Double(x)
        self.y = Double(y)
        colorProgressionBase = Double(x + y)
        
        isDynamic = false
        collisionType = 0
        collisionPriority = 99
        name = "hazard block"
        hitboxType = HitboxType.block
        isDangerous = true
        zPos = 5
        
        defaultSpriteColor = UIColor.purple
        shader = BlockShaders.hazardBlockShader
        
        load()
    }
    
    init(x: Int, y: Int, invertVisible: Bool) {
        super.init()
        
        self.x = Double(x)
        self.y = Double(y)
        self.invertExclusive = true
        self.invertVisible = invertVisible
        
        isDynamic = false
        collisionType = 0
        collisionPriority = 99
        name = "hazard block"
        hitboxType = HitboxType.block
        isDangerous = true
        zPos = 5
        
        defaultSpriteColor = UIColor.purple
        shader = BlockShaders.hazardBlockShader
        
        load()
    }
    
    override func update(delta: TimeInterval) {
        super.update(delta: delta)
    }
    
    override func updateAttributes() {
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: (extendL) ? 1:0), forAttribute: "a_extendL")
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: (extendR) ? 1:0), forAttribute: "a_extendR")
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: (extendT) ? 1:0), forAttribute: "a_extendT")
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: (extendB) ? 1:0), forAttribute: "a_extendB")
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: (extendTL) ? 1:0), forAttribute: "a_extendTL")
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: (extendTR) ? 1:0), forAttribute: "a_extendTR")
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: (extendBL) ? 1:0), forAttribute: "a_extendBL")
        (sprite as! SKSpriteNode).setValue(SKAttributeValue(float: (extendBR) ? 1:0), forAttribute: "a_extendBR")
    }
    
    override func gameActionFirstFrame(_ action: GameAction) {
        super.gameActionFirstFrame(action)
        
        switch(action) {
        case .rotateLeft:
            let temp = extendT
            extendT = extendR
            extendR = extendB
            extendB = extendL
            extendL = temp
            let temp2 = extendTL
            extendTL = extendTR
            extendTR = extendBR
            extendBR = extendBL
            extendBL = temp2
            break
        case .rotateRight:
            let temp = extendT
            extendT = extendL
            extendL = extendB
            extendB = extendR
            extendR = temp
            let temp2 = extendTL
            extendTL = extendBL
            extendBL = extendBR
            extendBR = extendTR
            extendTR = temp2
            break
        case .rotateLeftInstant:
            let temp = extendT
            extendT = extendR
            extendR = extendB
            extendB = extendL
            extendL = temp
            let temp2 = extendTL
            extendTL = extendTR
            extendTR = extendBR
            extendBR = extendBL
            extendBL = temp2
            break
        case .rotateRightInstant:
            let temp = extendT
            extendT = extendL
            extendL = extendB
            extendB = extendR
            extendR = temp
            let temp2 = extendTL
            extendTL = extendBL
            extendBL = extendBR
            extendBR = extendTR
            extendTR = temp2
            break
        default:
            break
        }
    }
    
    override func load() {
        sprite = SKSpriteNode.init(color: defaultSpriteColor, size: CGSize.init(width: Board.blockSize * (1 + (edgeSize * 2)), height: Board.blockSize * (1 + (edgeSize * 2))))
        (sprite as! SKSpriteNode).shader = shader
        if(!GameState.shadersEnabledDebug) {
            (sprite as! SKSpriteNode).shader = nil
        }
        
        sprite.zPosition = zPos
        sprite.position = CGPoint(x: x * Board.blockSize, y: -y * Board.blockSize)
    }
}
