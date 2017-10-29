//
//  EditorMenuOpenButton.swift
//  coolGame
//
//  Created by Nick Seel on 6/23/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class EditorMenuOpenButton: EditorButton {
    
    init(x: Double, y: Double, height: Double) {
        super.init(x: x, y: y)
        
        let width = height * 0.6
        sprite = SKShapeNode.init(rect: CGRect.init(x: width / -2, y: height / -2, width: width, height: height), cornerRadius: CGFloat(height * 0.1))
        (sprite as! SKShapeNode).strokeColor = UIColor.init(white: 0.4, alpha: 1.0)
        (sprite as! SKShapeNode).fillColor = UIColor.init(white: 0.0, alpha: 1.0)
        (sprite as! SKShapeNode).lineWidth = 3
        sprite.position = CGPoint(x: x, y: y)
        sprite.zPosition = 0
    }
    
    init(x: Double, y: Double, height: Double, width: Double) {
        super.init(x: x, y: y)
        
        sprite = SKShapeNode.init(rect: CGRect.init(x: width / -2, y: height / -2, width: width, height: height), cornerRadius: CGFloat(height * 0.1))
        (sprite as! SKShapeNode).strokeColor = UIColor.init(white: 0.4, alpha: 1.0)
        (sprite as! SKShapeNode).fillColor = UIColor.init(white: 0.0, alpha: 1.0)
        (sprite as! SKShapeNode).lineWidth = 3
        sprite.position = CGPoint(x: x, y: y)
        sprite.zPosition = 0
    }
}
