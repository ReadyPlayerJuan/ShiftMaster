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
    static var colorfulBlockShader: SKShader!
    static var colorfulTriangleShader: SKShader!
    
    class func initShaders() {
        if(!shadersLoaded) {
            shadersLoaded = true
            
            
            defaultBlockShader = SKShader.init(source:
                "void main() {" +
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
            
            
            colorfulTriangleShader = SKShader.init(source:
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
                    "gl_FragColor = a_color;" +
                "}" )
            colorfulTriangleShader.attributes = [SKAttribute(name: "a_direction", type: .float), SKAttribute(name: "a_color", type: .vectorFloat4)]
            colorfulTriangleShader.addUniform(SKUniform.init(name: "u_board_direction"))
            colorfulTriangleShader.uniformNamed("u_board_direction")?.floatValue = 0
            
            
            colorfulBlockShader = SKShader.init(source:
                "void main() {" +
                    "gl_FragColor = a_color;" +
                "}" )
            colorfulBlockShader.attributes = [SKAttribute(name: "a_color", type: .vectorFloat4)]
        }
    }
    
    class func updateDirection() {
        triangleBlockShader.uniformNamed("u_board_direction")?.floatValue = Float(Board.direction)
        colorfulTriangleShader.uniformNamed("u_board_direction")?.floatValue = Float(Board.direction)
    }
}
