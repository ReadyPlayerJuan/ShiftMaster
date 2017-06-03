//
//  PlayerShader.swift
//  coolGame
//
//  Created by Nick Seel on 6/2/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerShader {
    static var shaderLoaded = false
    
    static var shader: SKShader!
    
    class func initShader() {
        if(!shaderLoaded) {
            shaderLoaded = true
            
            
            shader = SKShader.init(source:
                "void main() {" +
                    "vec2 position = v_tex_coord;" +
                    "float distanceToEdge = 0.5 - abs(0.5 - position.x);" +
                    "if(position.y > distanceToEdge * pow(3.0, 0.5)) {" +
                    "   discard;" +
                    "}" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
            shader.attributes = [SKAttribute(name: "a_player_position", type: .vectorFloat2)]
        }
    }
}
