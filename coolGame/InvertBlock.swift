//
//  InvertBlock.swift
//  coolGame
//
//  Created by Nick Seel on 6/4/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class InvertBlock: Entity {
    var direction: Int = 0
    
    init(x: Int, y: Int, direction: Int) {
        super.init()
        
        self.x = Double(x)
        self.y = Double(y)
        self.direction = direction
        
        isDynamic = false
        collisionType = -1
        collisionPriority = 99
        name = "invert block"
        hitboxType = HitboxType.block
        zPos = 3
        
        defaultSpriteColor = UIColor.purple
        shader = BlockShaders.colorfulTriangleShader
        
        load()
    }
    
    override func update(delta: TimeInterval) {
        super.update(delta: delta)
    }
    
    override func updateAttributes() {
        let cycle = 2.0
        let numColors = ColorTheme.colors[Board.colorTheme].count
        var progression = GameState.time - Double(Int(GameState.time/cycle))*cycle
        progression -= (cycle/2.0)
        progression *= (2.0/cycle)
        let decreasing = (progression < 0)
        progression = abs(progression)
        progression *= Double(numColors-1)
        
        var currentColor = Int(progression)
        var nextColor = Int(progression)+1
        var colorProgression = progression - Double(Int(progression))
        if(decreasing) {
            currentColor += 1
            nextColor -= 1
            colorProgression = 1-colorProgression
        }
        if(currentColor >= 6) {
            currentColor = 5
        }
        
        var r = (Double(1-colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][currentColor][0])/255.0))
        r += (Double(colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][nextColor][0])/255.0))
        var g = (Double(1-colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][currentColor][1])/255.0))
        g += (Double(colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][nextColor][1])/255.0))
        var b = (Double(1-colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][currentColor][2])/255.0))
        b += (Double(colorProgression) * (Double(ColorTheme.colors[Board.colorTheme][nextColor][2])/255.0))
        
        sprite.setValue(SKAttributeValue(vectorFloat4: vector_float4([Float(r), Float(g), Float(b), 1])), forAttribute: "a_color")
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
