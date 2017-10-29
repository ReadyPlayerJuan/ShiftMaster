//
//  EditorMainMenuButton.swift
//  coolGame
//
//  Created by Nick Seel on 6/26/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class EditorMainMenuButton: EditorButton {
    var text: String = ""
    
    init(x: Double, y: Double, width: Double, height: Double, text: String) {
        super.init(x: x, y: y)
        self.text = text
        
        sprite = SKShapeNode.init(rect: CGRect.init(x: (width / -2), y: (height / -2), width: width, height: height))
        sprite.position = CGPoint(x: x, y: y)
        (sprite as! SKShapeNode).fillColor = UIColor.init(white: 0.8, alpha: 1.0)
        (sprite as! SKShapeNode).strokeColor = UIColor.init(white: 0.4, alpha: 1.0)
        (sprite as! SKShapeNode).lineWidth = 3
        sprite.zPosition = 1
        
        let label = SKLabelNode.init(text: text)
        label.fontSize = CGFloat(height * 0.6)
        label.fontName = "Menlo-BoldItalic"
        label.fontColor = UIColor.init(white: 0.1, alpha: 1.0)
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.zPosition = 1
        
        sprite.addChild(label)
    }
}
