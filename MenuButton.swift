//
//  MenuButton.swift
//  coolGame
//
//  Created by Nick Seel on 2/24/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class MenuButton {
    var rect: CGRect
    var color: UIColor = UIColor.purple
    var textColor: UIColor = UIColor.black
    
    var isPressed = false
    
    var alpha = CGFloat(1.0)
    var label: SKLabelNode!
    
    init(x: Double, y: Double, width: Double, height: Double, text: String, textColor: UIColor, color: UIColor) {
        rect = CGRect.init(x: x, y: y, width: width, height: height)
        
        label = SKLabelNode.init(text: text)
        label.fontColor = textColor
        label.fontSize = CGFloat(height) * 0.8
        label.fontName = "Optima-Bold"
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.baseline
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label.position = CGPoint(x: rect.midX, y: rect.midY - (label.fontSize / 4.0))
        
        let shadeResolution = 8
        let maxShadeOpacity = 0.7
        for i in 0...shadeResolution-1 {
            let inc = CGFloat(((Double(i) / Double(shadeResolution)) - 0.6) * height) / 1.3
            let a = SKShapeNode.init(path: UIBezierPath.init(roundedRect: CGRect.init(x: (CGFloat(width) / -2) - inc, y: ((CGFloat(height) - label.frame.height) / -2) - inc, width: CGFloat(width) + (inc*2), height: CGFloat(height) + (inc*2)), cornerRadius: max(0, ((CGFloat(height) + (inc*2)) * 0.32))).cgPath)
            a.fillColor = UIColor.white
            a.strokeColor = UIColor.clear
            a.alpha = CGFloat(maxShadeOpacity / Double(shadeResolution))
            label.addChild(a)
        }
    }
    
    func update() {
        label.alpha = alpha
        for t in InputController.currentTouches {
            if(rect.contains(t)) {
                isPressed = true
            }
        }
    }
}
