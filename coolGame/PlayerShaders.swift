//
//  PlayerShader.swift
//  coolGame
//
//  Created by Nick Seel on 6/2/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerShaders {
    static var shadersLoaded = false
    
    static var defaultShader: SKShader!
    static var waveShader: SKShader!
    static var textureShader: SKShader!
    
    static var grayscaleTexture: SKTexture!
    static var grayscaleTexture2: SKTexture!
    
    class func initShaders() {
        if(!shadersLoaded) {
            shadersLoaded = true
            grayscaleTexture = SKTexture.init(image: UIImage.init(named: "grayscaleTexture")!)
            grayscaleTexture2 = SKTexture.init(image: UIImage.init(named: "grayscaleTexture2")!)
            
            
            defaultShader = SKShader.init(source:
                "void main() {" +
                    "vec2 frag_position = v_tex_coord;" +
                    "float distanceToEdge = 0.5 - abs(0.5 - frag_position.x);" +
                    "if(frag_position.y > distanceToEdge * pow(3.0, 0.5)) {" +
                    "   discard;" +
                    "}" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
            defaultShader.attributes = [SKAttribute(name: "a_player_position", type: .vectorFloat2)]
            
            
            waveShader = SKShader.init(source:
                "void main() {" +
                    "vec2 frag_position = v_tex_coord;" +
                    "float distanceToEdge = 0.5 - abs(0.5 - frag_position.x);" +
                    "if(frag_position.y > distanceToEdge * pow(3.0, 0.5)) {" +
                    "   discard;" +
                    "}" +
                    "" +
                    "vec2 center = vec2(0.5, pow(3.0, 0.5) / 6.0);" +
                    "float distanceToCenter = pow(length(vec2(frag_position - center)) / (pow(3.0, 0.5) / 3.0), 0.5);" +
                    "float progress = (a_time_passed * (1 + u_outside_delay)) - (distanceToCenter * u_outside_delay);" +
                    "progress = min(max(progress, 0.0), 1.0);" +
                    "progress *= mix(u_num_waves_min, u_num_waves, pow(progress, 1));" +
                    "" +
                    "float waveNum = floor(progress);" +
                    "float wavePct = progress - waveNum;" +
                    "wavePct = 1 - ((cos(wavePct * 3.14159) + 1) / 2);" +
                    "if(mod(waveNum, 2.0) == 1.0) {" +
                    "   wavePct = 1.0 - wavePct;" +
                    "}" +
                    "" +
                    "gl_FragColor = mix(SKDefaultShading(), a_new_color, wavePct);" +
                "}" )
            waveShader.attributes = [SKAttribute(name: "a_time_passed", type: .float), SKAttribute(name: "a_new_color", type: .vectorFloat4)]
            waveShader.addUniform(SKUniform(name: "u_num_waves_min", float: 3.0))
            waveShader.addUniform(SKUniform(name: "u_num_waves", float: 9.0))
            waveShader.addUniform(SKUniform(name: "u_wave_time", float: 0.2))
            waveShader.addUniform(SKUniform(name: "u_outside_delay", float: 0.3))
            
            
            textureShader = SKShader.init(source:
                "void main() {" +
                    "vec2 frag_position = v_tex_coord;" +
                    "float distanceToEdge = 0.5 - abs(0.5 - frag_position.x);" +
                    "if(frag_position.y > distanceToEdge * pow(3.0, 0.5)) {" +
                    "   discard;" +
                    "}" +
                    "vec2 texCoords = vec2(1-v_tex_coord.x, 1-(v_tex_coord.y + 0.5 - (pow(3.0, 0.5) / 6.0)));" +
                    "vec4 texColor = texture2D(u_new_texture, texCoords);" +
                    "" +
                    "float waveTime = u_wave_time;" +
                    "float colorProgression = 0;" +
                    "colorProgression = mix(texColor.r, (v_tex_coord.x + v_tex_coord.y) / 2, u_coord_mix);" +
                    "" +
                    "float mixValue = (((a_time_passed * (1 + waveTime)) - colorProgression) / waveTime);" +
                    "mixValue = min(1.0, max(0.0, mixValue));" +
                    "gl_FragColor = mix(SKDefaultShading(), a_new_color, mixValue);" +
                "}" )
            textureShader.attributes = [SKAttribute(name: "a_time_passed", type: .float), SKAttribute(name: "a_new_color", type: .vectorFloat4)]
            textureShader.addUniform(SKUniform(name: "u_new_texture", texture: grayscaleTexture))
            textureShader.addUniform(SKUniform(name: "u_wave_time", float: 0.5))
            textureShader.addUniform(SKUniform(name: "u_coord_mix", float: 0.6))
        }
    }
    
    class func getRandomColorChangeShader() -> SKShader {
        let shaderNum = Int(rand() * 3)
        switch(shaderNum) {
        case 0:
            return waveShader
        case 1:
            textureShader.uniformNamed("u_new_texture")?.textureValue = grayscaleTexture
            textureShader.uniformNamed("u_coord_mix")?.floatValue = 0.6
            return textureShader
        case 2:
            textureShader.uniformNamed("u_new_texture")?.textureValue = grayscaleTexture2
            textureShader.uniformNamed("u_coord_mix")?.floatValue = 0.0
            return textureShader
        default:
            print("out of bounds player shader selection")
            return defaultShader
        }
    }
    
    private class func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
