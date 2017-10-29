//
//  PostShader.swift
//  coolGame
//
//  Created by Nick Seel on 6/2/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class PostShaders {
    static var shadersLoaded = false
    
    static var defaultShader: SKShader!
    static var invertShader: SKShader!
    static var invertCircleTransitionShader: SKShader!
    
    class func initShaders() {
        if(!shadersLoaded) {
            shadersLoaded = true
            
            
            defaultShader = SKShader.init(source:
                "void main() {" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
            
            
            invertShader = SKShader.init(source:
                "void main() {" +
                    "if(u_inverted > 0.5) {" +
                    "   gl_FragColor = vec4(1 - SKDefaultShading().rgb, SKDefaultShading().a);" +
                    "} else {" +
                    "   gl_FragColor = SKDefaultShading();" +
                    "}" +
                "}" )
            invertShader.addUniform(SKUniform(name: "u_inverted", float: 0))
            
            
            invertCircleTransitionShader = SKShader.init(source:
                "void main() {" +
                    "float maxDistance = pow((u_aspectRatio * u_aspectRatio) + 1.0, 0.5);" +
                    "vec2 coords = (v_tex_coord - vec2(0.5, 0.5)) * 2;" +
                    "coords.x *= u_aspectRatio;" +
                    "float distance = pow((coords.x * coords.x) + (coords.y * coords.y), 0.5) / maxDistance;" +
                    "" +
                    "vec4 inverseColor = vec4(0, 0, 0, 0);" +
                    "vec4 originalColor = vec4(0, 0, 0, 0);" +
                    "vec4 betweenColor = vec4(0, 0, 0, 0);" +
                    "" +
                    "if(u_inverted < 0.5) {" +
                    "   originalColor = SKDefaultShading();" +
                    "   inverseColor = vec4(1 - SKDefaultShading().rgb, SKDefaultShading().a);" +
                    "   float a = mod(((v_tex_coord.x * u_aspectRatio) + v_tex_coord.y) * 4, 1);" +
                    "   if(a < 0.5) {" +
                    "       v_tex_coord += vec2(0.005, 0.005);" +
                    "   } else {" +
                    "       v_tex_coord += vec2(-0.01, 0.0);" +
                    "   }" +
                    "   betweenColor = SKDefaultShading();" +
                    "   betweenColor = vec4(betweenColor.g, 1-betweenColor.b, (1+betweenColor.r)/2, betweenColor.a);" +
                    "} else {" +
                    "   inverseColor = SKDefaultShading();" +
                    "   originalColor = vec4(1 - SKDefaultShading().rgb, SKDefaultShading().a);" +
                    "   float a = mod(((v_tex_coord.x * u_aspectRatio) + v_tex_coord.y) * 4, 1);" +
                    "   if(a < 0.5) {" +
                    "       v_tex_coord += vec2(0.005, 0.005);" +
                    "   } else {" +
                    "       v_tex_coord += vec2(-0.01, 0.0);" +
                    "   }" +
                    "   betweenColor = SKDefaultShading();" +
                    "   betweenColor = vec4(betweenColor.g, 1-betweenColor.b, (1+betweenColor.r)/2, betweenColor.a);" +
                    "   betweenColor = vec4(1 - betweenColor.rgb, betweenColor.a);" +
                    "}" +
                    "" +
                    "" +
                    "if(distance > u_circleRadius0) {" +
                    "   gl_FragColor = originalColor;" +
                    "} else {" +
                    "   if(distance > u_circleRadius1) {" +
                    "       gl_FragColor = betweenColor;" +
                    "   } else {" +
                    "       gl_FragColor = inverseColor;" +
                    "   }" +
                    "}" +
                "}" )
            invertCircleTransitionShader.addUniform(SKUniform(name: "u_time_passed", float: 1))
            invertCircleTransitionShader.addUniform(SKUniform(name: "u_aspectRatio", float: Float(GameState.screenWidth / GameState.screenHeight)))
            invertCircleTransitionShader.addUniform(SKUniform(name: "u_circleRadius0", float: 0))
            invertCircleTransitionShader.addUniform(SKUniform(name: "u_circleRadius1", float: 0))
            invertCircleTransitionShader.addUniform(SKUniform(name: "u_inverted", float: 0))
        }
    }
}
