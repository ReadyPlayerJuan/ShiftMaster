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
    static var hazardBlockShader: SKShader!
    static var colorfulBlockShader: SKShader!
    static var colorfulTriangleShader: SKShader!
    
    static var invertBlockShader: SKShader!
    static var invertTriangleShader: SKShader!
    
    class func initShaders() {
        if(!shadersLoaded) {
            shadersLoaded = true
            
            
            defaultBlockShader = SKShader.init(source:
                "void main() {" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
            //defaultBlockShader = nil
            defaultBlockShader.attributes = [SKAttribute(name: "a_block_position", type: .vectorFloat2), SKAttribute(name: "a_player_position", type: .vectorFloat2)]
            
            triangleBlockShader = SKShader.init(source:
                "void main() {" +
                    "vec2 position = v_tex_coord;" +
                    "float direction = mod(a_direction - u_board_direction + 4.0, 4.0);" +
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
            triangleBlockShader.addUniform(SKUniform.init(name: "u_board_direction", float: Float(0)))
            //triangleBlockShader = nil
            
            
            hazardBlockShader = SKShader.init(source:
                "void main() {" +
                    "vec2 blockCoords = (v_tex_coord * (1.0 + (edge * 2.0))) - edge;" +
                    "vec4 color = vec4(0, 0, 0, 0);" +
                    "" +
                    "" +
                    "vec2 rCoords = blockCoords + rOffset;" +
                    "if((a_extendL > 0.5 || rCoords.x > -effectSize) && (a_extendR > 0.5 || rCoords.x < 1.0+effectSize) && (a_extendB > 0.5 || rCoords.y > -effectSize) && (a_extendT > 0.5 || rCoords.y < 1.0+effectSize)) {" +
                    "       color += vec4(1, 0, 0, alpha);" +
                    //"   }" +
                    "}" +
                    "" +
                    "vec2 gCoords = blockCoords + gOffset;" +
                    "if((a_extendL > 0.5 || gCoords.x > -effectSize) && (a_extendR > 0.5 || gCoords.x < 1.0+effectSize) && (a_extendB > 0.5 || gCoords.y > -effectSize) && (a_extendT > 0.5 || gCoords.y < 1.0+effectSize)) {" +
                    "       color += vec4(0, 1, 0, alpha);" +
                    "}" +
                    "" +
                    "vec2 bCoords = blockCoords + bOffset;" +
                    "if((a_extendL > 0.5 || bCoords.x > -effectSize) && (a_extendR > 0.5 || bCoords.x < 1.0+effectSize) && (a_extendB > 0.5 || bCoords.y > -effectSize) && (a_extendT > 0.5 || bCoords.y < 1.0+effectSize)) {" +
                    "       color += vec4(0, 0, 1, alpha);" +
                    "}" +
                    "" +
                    "if(color.r == 1.0 && color.g == 1.0 && color.b == 1.0) {" +
                    "   color = mix(color, innerColor, 0.22);" +
                    "}" +
                    "" +
                    "gl_FragColor = color;" +
                "}" )
            hazardBlockShader.attributes = [SKAttribute(name: "a_extendL", type: .float), SKAttribute(name: "a_extendR", type: .float), SKAttribute(name: "a_extendT", type: .float), SKAttribute(name: "a_extendB", type: .float), SKAttribute(name: "a_extendTL", type: .float), SKAttribute(name: "a_extendTR", type: .float), SKAttribute(name: "a_extendBL", type: .float), SKAttribute(name: "a_extendBR", type: .float)]
            hazardBlockShader.addUniform(SKUniform(name: "rOffset", float: GLKVector2(v: (0, 0))))
            hazardBlockShader.addUniform(SKUniform(name: "gOffset", float: GLKVector2(v: (0, 0))))
            hazardBlockShader.addUniform(SKUniform(name: "bOffset", float: GLKVector2(v: (0, 0))))
            hazardBlockShader.addUniform(SKUniform(name: "effectSize", float: Float(-0.1)))
            hazardBlockShader.addUniform(SKUniform(name: "edge", float: Float(0)))
            hazardBlockShader.addUniform(SKUniform(name: "alpha", float: Float(0.34)))
            hazardBlockShader.addUniform(SKUniform(name: "innerColor", float: GLKVector4(v: (0, 0, 0, 0))))
            //hazardBlockShader = nil
            
            
            colorfulTriangleShader = SKShader.init(source:
                "void main() {" +
                    "vec2 position = v_tex_coord;" +
                    "float direction = mod(a_direction - u_board_direction + 4.0, 4.0);" +
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
            colorfulTriangleShader.addUniform(SKUniform.init(name: "u_board_direction", float: Float(0)))
            
            
            colorfulBlockShader = SKShader.init(source:
                "void main() {" +
                    "gl_FragColor = a_color;" +
                "}" )
            colorfulBlockShader.attributes = [SKAttribute(name: "a_color", type: .vectorFloat4)]
            
            
            
            
            invertTriangleShader = SKShader.init(source:
                "void main() {" +
                    "vec2 position = v_tex_coord;" +
                    "float direction = mod(a_direction - u_board_direction + 4.0, 4.0);" +
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
                    "" +
                    "float maxDistance = pow((u_aspectRatio * u_aspectRatio) + 1.0, 0.5);" +
                    "vec2 coords = (v_tex_coord - vec2(0.5, 0.5)) * 2;" +
                    "coords.x *= u_aspectRatio;" +
                    "float distance = pow((coords.x * coords.x) + (coords.y * coords.y), 0.5) / maxDistance;" +
                    "" +
                    "if(distance > u_circleRadius0) {" +
                    "   gl_FragColor = vec4(0, 0, 0, 0);" +
                    "}" +
                    "" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
            invertTriangleShader.attributes = [SKAttribute(name: "a_direction", type: .float)]
            invertTriangleShader.addUniform(SKUniform(name: "u_board_direction", float: 0))
            invertTriangleShader.addUniform(SKUniform(name: "u_time_passed", float: 1))
            invertTriangleShader.addUniform(SKUniform(name: "u_aspectRatio", float: Float(GameState.screenWidth / GameState.screenHeight)))
            invertTriangleShader.addUniform(SKUniform(name: "u_circleRadius0", float: 0))
            invertTriangleShader.addUniform(SKUniform(name: "u_circleRadius1", float: 0))
            invertTriangleShader.addUniform(SKUniform(name: "u_inverted", float: 0))
        }
    }
}
