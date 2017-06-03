//
//  BlockShaders.swift
//  coolGame
//
//  Created by Nick Seel on 5/19/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class BlockShaders {
    static var shadersLoaded = false
    
    static var defaultBlockShader: SKShader!
    static var triangleBlockShader: SKShader!
    
    class func initShaders() {
        if(!shadersLoaded) {
            shadersLoaded = true
            
            
            defaultBlockShader = SKShader.init(source:
                "void main() {" +
                    //"vec2 position = a_block_position + v_tex_coord;" +
                    //"float distanceToCircle = length(position - a_tap_position);" +
                    //"distanceToCircle  = pow(distanceToCircle - 0.5, 2);" +
                    //"float invertValue = clamp(distanceToCircle, 0.0, 1.0);" +
                    //"gl_FragColor = mix(SKDefaultShading(), 1-SKDefaultShading(), invertValue);" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
            //defaultBlockShader.attributes = [SKAttribute(name: "a_block_position", type: .vectorFloat2), SKAttribute(name: "a_player_position", type: .vectorFloat2)]
            
            triangleBlockShader = SKShader.init(source:
                "void main() {" +
                    "vec2 position = v_tex_coord;" +
                    "float direction = mod(a_direction - u_board_direction + 4, 4);" +
                    "if(direction < 0.5) {" +
                    "   float distanceToEdge = 0.5 - abs(0.5 - position.x);" +
                    "   if(position.y > distanceToEdge * pow(3.0, 0.5)) {" +
                    "       gl_FragColor = vec4(0, 0, 0, 0);" +
                    "   }" +
                    "} else if(direction < 1.5) {" +
                    "   float distanceToEdge = 0.5 - abs(0.5 - position.y);" +
                    "   if(1 - position.x > distanceToEdge * pow(3.0, 0.5)) {" +
                    "       gl_FragColor = vec4(0, 0, 0, 0);" +
                    "   }" +
                    "} else if(direction < 2.5) {" +
                    "   float distanceToEdge = 0.5 - abs(0.5 - position.x);" +
                    "   if(1 - position.y > distanceToEdge * pow(3.0, 0.5)) {" +
                    "       gl_FragColor = vec4(0, 0, 0, 0);" +
                    "   }" +
                    "} else {" +
                    "   float distanceToEdge = 0.5 - abs(0.5 - position.y);" +
                    "   if(position.x > distanceToEdge * pow(3.0, 0.5)) {" +
                    "       gl_FragColor = vec4(0, 0, 0, 0);" +
                    "   }" +
                    "}" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
            triangleBlockShader.attributes = [SKAttribute(name: "a_direction", type: .float)]
            triangleBlockShader.addUniform(SKUniform.init(name: "u_board_direction"))
            triangleBlockShader.uniformNamed("u_board_direction")?.floatValue = 0
        }
    }
}
