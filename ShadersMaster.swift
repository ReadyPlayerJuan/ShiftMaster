//
//  ShadersMaster.swift
//  coolGame
//
//  Created by Nick Seel on 6/16/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class ShadersMaster {
    class func initShaders() {
        BlockShaders.initShaders()
        PlayerShaders.initShaders()
        PostShaders.initShaders()
    }
    
    class func updateInvertAnimation(timePassed: Float) {
        let length = 0.96
        let mix = 0.25
        let range = 4.0
        let boost = 0.1
        let base = Double(timePassed)
        let r0 = (Double(timePassed) - 0.0) / (length - 0.0)
        var radius0 = (mix * pow(((base + r0) / 2) * range, 0.5) / pow(range, 0.5))
        radius0 += ((1-mix) * pow(r0 + boost, 8))
        let r1 = (Double(timePassed) - (1-length)) / (1.0 - (1-length))
        var radius1 = (mix * pow(((base + r1) / 2) * range, 0.5) / pow(range, 0.5))
        radius1 += ((1-mix) * pow(r1 + boost, 8))
        
        PostShaders.invertCircleTransitionShader.uniformNamed("u_time_passed")?.floatValue = timePassed
        PostShaders.invertCircleTransitionShader.uniformNamed("u_circleRadius0")?.floatValue = Float(radius0)
        PostShaders.invertCircleTransitionShader.uniformNamed("u_circleRadius1")?.floatValue = Float(radius1)
        BlockShaders.invertTriangleShader.uniformNamed("u_time_passed")?.floatValue = timePassed
        BlockShaders.invertTriangleShader.uniformNamed("u_circleRadius0")?.floatValue = Float(radius0)
        BlockShaders.invertTriangleShader.uniformNamed("u_circleRadius1")?.floatValue = Float(radius1)
    }
    
    class func updateInvertState(inverted: Bool) {
        PostShaders.invertShader.uniformNamed("u_inverted")?.floatValue = (inverted) ? 1 : 0
        PostShaders.invertCircleTransitionShader.uniformNamed("u_inverted")?.floatValue = (inverted) ? 1 : 0
        PostShaders.invertCircleTransitionShader.uniformNamed("u_time_passed")?.floatValue = 0
        BlockShaders.invertTriangleShader.uniformNamed("u_inverted")?.floatValue = (inverted) ? 1 : 0
        BlockShaders.invertTriangleShader.uniformNamed("u_time_passed")?.floatValue = 0
    }
    
    class func updateHazardBlockAnimation() {
        let size = 0.175
        BlockShaders.hazardBlockShader.uniformNamed("rOffset")?.floatVector2Value = GLKVector2(v: (Float((self.rand() * size) - (size / 2)), Float((self.rand() * size) - (size / 2))))
        BlockShaders.hazardBlockShader.uniformNamed("gOffset")?.floatVector2Value = GLKVector2(v: (Float((self.rand() * size) - (size / 2)), Float((self.rand() * size) - (size / 2))))
        BlockShaders.hazardBlockShader.uniformNamed("bOffset")?.floatVector2Value = GLKVector2(v: (Float((self.rand() * size) - (size / 2)), Float((self.rand() * size) - (size / 2))))
        
        let hazardCycle = 3.0
        var c = GameState.time / (2 * hazardCycle)
        
        if(GameState.currentActions.count > 0) {
            for i in 0...GameState.currentActions.count-1 {
                if(GameState.currentActions[i].gameAction == GameAction.rotateLeft || GameState.currentActions[i].gameAction == GameAction.rotateRight) {
                    let ang = GameState.skewToEdges(pct: GameState.currentActionPercents[i], power: 4)
                    c += hazardCycle * (1-ang) * 2
                } else if(GameState.currentActions[i].gameAction == GameAction.respawningPlayer) {
                    let ang = GameState.skewToEdges(pct: GameState.currentActionPercents[i], power: 4)
                    c += hazardCycle * (1-ang) * abs(GameState.maxDeathRotation / (3.14159 / 2)) * 2
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
        
        BlockShaders.hazardBlockShader.uniformNamed("innerColor")?.floatVector4Value = GLKVector4(v: (Float(r), Float(g), Float(b), 1.0))
        
        
        var time = GameState.time / 8.0;
        time = (time * 2) - (Double(Int(time)) * 2)
        
        BlockShaders.hazardBlockShader.uniformNamed("time")?.floatValue = Float(time)
    }
    
    class func updateDirection() {
        BlockShaders.triangleBlockShader.uniformNamed("u_board_direction")?.floatValue = Float(Board.direction)
        BlockShaders.colorfulTriangleShader.uniformNamed("u_board_direction")?.floatValue = Float(Board.direction)
        BlockShaders.invertTriangleShader.uniformNamed("u_board_direction")?.floatValue = Float(Board.direction)
    }
    
    private class func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
