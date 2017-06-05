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
    var colorProgressionBase: Double = 0
    let hazardCycle: Double = 15.0
    
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
        zPos = 1
        
        defaultSpriteColor = UIColor.purple
        shader = BlockShaders.colorfulBlockShader
        
        load()
    }
    
    override func update(delta: TimeInterval) {
        super.update(delta: delta)
    }
    
    override func updateAttributes() {
        var c = colorProgressionBase + (EntityManager.getPlayer()! as! Player).movementTotal + (GameState.time / (2 * hazardCycle))
        
        if(GameState.currentActions.count > 0) {
            for i in 0...GameState.currentActions.count-1 {
                if(GameState.currentActions[i].gameAction == GameAction.rotateLeft || GameState.currentActions[i].gameAction == GameAction.rotateRight) {
                    let ang = GameState.skewToEdges(pct: GameState.currentActionPercents[i], power: 4)
                    c += hazardCycle * (1-ang)
                } else if(GameState.currentActions[i].gameAction == GameAction.respawningPlayer) {
                    let ang = GameState.skewToEdges(pct: GameState.currentActionPercents[i], power: 4)
                    c += hazardCycle * (1-ang) * abs(GameState.maxDeathRotation / (3.14159 / 2))
                }
            }
        }
        
        let colorProgression = abs((remainder(c, hazardCycle) + (hazardCycle/2.0)) / hazardCycle) + (GameState.time / (2 * hazardCycle))
        
        var r = remainder(colorProgression + 0.0, 1.0) + 0.5
        var g = remainder(colorProgression + 0.333, 1.0) + 0.5
        var b = remainder(colorProgression + 0.666, 1.0) + 0.5
        r = abs((r * 2) - 1)
        g = abs((g * 2) - 1)
        b = abs((b * 2) - 1)
        
        let flickerTogether = true || false
        var rand = 0.0
        if(!flickerTogether) {
            rand = self.rand()
        } else {
            rand = GameState.globalRand
        }
        let flicker = (1 * (pow(rand * 0.9, 4) - 0.5) / 2) + 0.2
        r = min(1.0, max(0.0, r + flicker))
        g = min(1.0, max(0.0, g + flicker))
        b = min(1.0, max(0.0, b + flicker))
        
        sprite.setValue(SKAttributeValue(vectorFloat4: vector_float4([Float(r), Float(g), Float(b), 1])), forAttribute: "a_color")
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
