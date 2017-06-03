//
//  PostShader.swift
//  coolGame
//
//  Created by Nick Seel on 6/2/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class PostShader {
    static var shaderLoaded = false
    
    static var shader: SKShader!
    
    class func initShader() {
        if(!shaderLoaded) {
            shaderLoaded = true
            
            
            shader = SKShader.init(source:
                "void main() {" +
                    "gl_FragColor = SKDefaultShading();" +
                "}" )
        }
    }
}
