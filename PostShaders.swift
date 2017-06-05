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
    
    class func initShaders() {
        if(!shadersLoaded) {
            shadersLoaded = true
            
            
            defaultShader = SKShader.init(source:
                "void main() {" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
            
            
            invertShader = SKShader.init(source:
                "void main() {" +
                    "gl_FragColor = vec4(1 - SKDefaultShading().rgb, SKDefaultShading().a);" +
                    "" +
                    "" +
                    "" +
                    "" +
                    "" +
                    "" +
                    "" +
                    "" +
                    "" +
                    "" +
                "}" )
            //invertShader.addUniform(<#T##uniform: SKUniform##SKUniform#>)
        }
    }
}
