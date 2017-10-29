//
//  Button.swift
//  coolGame
//
//  Created by Nick Seel on 2/13/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class EditorBlockButton: EditorButton {
    var block: Entity!
    
    init(x: Double, y: Double, size: Double, block: Entity) {
        super.init(x: x, y: y)
        self.block = block
        
        sprite = SKSpriteNode(color: UIColor.init(white: 0.4, alpha: 1.0), size: CGSize(width: Board.blockSize * size, height: Board.blockSize * size))
        sprite.position = CGPoint(x: x, y: y)
        sprite.zPosition = 0
        
        let innerBoxSize = 0.95
        let innerBox = SKSpriteNode(color: UIColor.black, size: CGSize(width: Board.blockSize * size * innerBoxSize, height: Board.blockSize * size * innerBoxSize))
        innerBox.zPosition = 1
        sprite.addChild(innerBox)
        
        block.sprite.position = CGPoint(x: 0, y: 0)
        block.sprite.xScale = CGFloat(innerBoxSize * size)
        block.sprite.yScale = CGFloat(innerBoxSize * size)
        sprite.addChild(block.sprite)
        
        /*rect = CGRect.init(x: x, y: y, width: width, height: height)
        buttonRect = CGRect.init(x: x-leniency, y: y-leniency, width: width+(leniency*2), height: height+(leniency*2))
        self.colorIndex = colorIndex
        self.type = type
        loadColor()
        
        switch(type) {
        case 0:
            sprite = [SKShapeNode.init(), SKShapeNode.init(rect: rect)]
            sprite[0].fillColor = UIColor.clear
            sprite[0].strokeColor = UIColor.clear
            break
        case 1:
            sprite = [SKShapeNode.init(rect: rect), SKShapeNode.init(rect: rect)]
            /*if(colorIndex == -3) {
                sprite[0] = SKShapeNode
            } else {*/
                sprite[0].fillColor = color
                sprite[0].strokeColor = UIColor.white
                sprite[0].lineWidth = 3
                sprite[0].zPosition = 101
            //}
            break
        case 2:
            let gray = CGFloat(0.6)
            let gray2 = CGFloat(0.2)
            color = UIColor.init(red: gray, green: gray, blue: gray, alpha: 1.0)
            let color2 = UIColor.init(red: gray2, green: gray2, blue: gray2, alpha: 1.0)
            sprite = [SKShapeNode.init(rect: rect), SKShapeNode.init(rect: rect)]
            sprite[0].fillColor = color//UIColor.init(red: gray, green: gray, blue: gray, alpha: 1.0)
            sprite[0].strokeColor = color2
            sprite[0].lineWidth = 3
            sprite[0].zPosition = 101
            if(colorIndex == 0) {
                let s = 0.6
                let vs = 0.15
                let offset = 0.05
                let arrowBody = SKShapeNode.init(rect: CGRect.init(x: (Double(width) * (0.5 + offset)) - ((s/2) * Double(width)), y: (Double(height) * (0.5)) - ((vs/2) * Double(height)), width: s*Double(width), height: vs*Double(height)))
                arrowBody.position = CGPoint(x: x, y: y)
                arrowBody.fillColor = color2
                arrowBody.strokeColor = UIColor.clear
                arrowBody.zPosition = 2
                let arrowHead = SKShapeNode.init(path: getTrianglePath(corner: CGPoint.init(x: Double(width)*((s / -2.0) + 0.47 - offset), y: Double(height)/2.0), rotation: 330, size: Double(height)*vs*2.5))
                arrowHead.position = CGPoint(x: x, y: y)
                arrowHead.fillColor = color2
                arrowHead.strokeColor = UIColor.clear
                arrowHead.zPosition = 2
                sprite[0].addChild(arrowBody)
                sprite[0].addChild(arrowHead)
            } else if(colorIndex == 1) {
                let s = 0.6
                let vs = 0.15
                let offset = 0.05
                let arrowBody = SKShapeNode.init(rect: CGRect.init(x: (Double(width) * (0.5 - offset)) - ((s/2) * Double(width)), y: (Double(height) * (0.5)) - ((vs/2) * Double(height)), width: s*Double(width), height: vs*Double(height)))
                arrowBody.position = CGPoint(x: x, y: y)
                arrowBody.fillColor = color2
                arrowBody.strokeColor = UIColor.clear
                arrowBody.zPosition = 2
                let arrowHead = SKShapeNode.init(path: getTrianglePath(corner: CGPoint.init(x: (Double(width)*((s/2.0) + 0.53 + offset)), y: Double(height)/2.0), rotation: 150, size: Double(height)*vs*2.5))
                arrowHead.position = CGPoint(x: x, y: y)
                arrowHead.fillColor = color2
                arrowHead.strokeColor = UIColor.clear
                arrowHead.zPosition = 2
                sprite[0].addChild(arrowBody)
                sprite[0].addChild(arrowHead)
            }
            break
        case 3:
            let gray = CGFloat(0.6)
            let gray2 = CGFloat(0.2)
            color = UIColor.init(red: gray, green: gray, blue: gray, alpha: 1.0)
            let color2 = UIColor.init(red: gray2, green: gray2, blue: gray2, alpha: 1.0)
            sprite = [SKShapeNode.init(rect: rect), SKShapeNode.init(rect: rect)]
            //sprite[1].position = CGPoint(x: -9999, y: -9999)
            sprite[0].fillColor = color
            sprite[0].strokeColor = color2
            sprite[0].lineWidth = 3
            sprite[0].zPosition = 101
            text = SKLabelNode.init(text: btext)
            text?.fontName = "Optima-Bold"
            text?.fontSize = rect.height * 0.8
            text?.position = CGPoint(x: rect.midX, y: rect.midY)
            text?.fontColor = UIColor.black
            text?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            text?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            text?.zPosition = 3
            sprite[0].addChild(text!)
            break
        case 4:
            let gray = CGFloat(0.6)
            color = UIColor.init(red: gray, green: gray, blue: gray, alpha: 1.0)
            sprite = [SKShapeNode.init(rect: rect), SKShapeNode.init(rect: rect)]
            //sprite[1].position = CGPoint(x: -9999, y: -9999)
            sprite[0].fillColor = color
            sprite[0].strokeColor = UIColor.white
            sprite[0].lineWidth = 3
            sprite[0].zPosition = 101
            text = SKLabelNode.init(text: btext)
            text?.fontName = "Optima-Bold"
            text?.fontSize = rect.height * 1.0
            text?.position = CGPoint(x: rect.midX, y: rect.midY)
            text?.fontColor = UIColor.white
            text?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            text?.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            text?.zPosition = 3
            sprite[0].addChild(text!)
            break
        case 5:
            let gray = CGFloat(0.35)
            let gray2 = CGFloat(0.55)
            color = UIColor.init(red: gray, green: gray, blue: gray, alpha: 1.0)
            let color2 = UIColor.init(red: gray2, green: gray2, blue: gray2, alpha: 1.0)
            sprite = [SKShapeNode.init(rect: rect), SKShapeNode.init(rect: rect)]
            sprite[1].position = CGPoint(x: -9999, y: -9999)
            sprite[0].fillColor = color
            sprite[0].strokeColor = color2
            sprite[0].lineWidth = 3
            sprite[0].zPosition = 101
            
            let path1 = UIBezierPath.init()
            let size = 0.05
            path1.move(to: CGPoint(x: 0, y: Double(rect.height)*size))
            path1.addLine(to: CGPoint(x: Double(rect.width)*size, y: 0))
            path1.addLine(to: CGPoint(x: Double(rect.width)*(1), y: Double(rect.height)*(1-size)))
            path1.addLine(to: CGPoint(x: Double(rect.width)*(1-size), y: Double(rect.height)*(1)))
            
            let line1 = SKShapeNode.init(path: path1.cgPath)
            line1.fillColor = UIColor.red
            line1.strokeColor = UIColor.clear
            line1.zPosition = 50
            
            let path2 = UIBezierPath.init()
            path2.move(to: CGPoint(x: Double(rect.width), y: Double(rect.height)*size))
            path2.addLine(to: CGPoint(x: Double(rect.width)*(1-size), y: 0))
            path2.addLine(to: CGPoint(x: Double(rect.width)*(0), y: Double(rect.height)*(1-size)))
            path2.addLine(to: CGPoint(x: Double(rect.width)*(size), y: Double(rect.height)*(1)))
            
            let line2 = SKShapeNode.init(path: path2.cgPath)
            line2.fillColor = UIColor.red
            line2.strokeColor = UIColor.clear
            
            line1.position = CGPoint(x: rect.minX, y: rect.minY)
            sprite[0].addChild(line1)
            line1.addChild(line2)
            break
        default:
            break
        }
        
        sprite[1].fillColor = UIColor.black
        sprite[1].strokeColor = UIColor.black
        sprite[1].alpha = 0.0
        sprite[1].zPosition = 110*/
    }
    
    override func update(active: Bool, delta: TimeInterval) {
        super.update(active: active, delta: delta)
        sprite.zRotation = CGFloat(Board.direction) * (3.14159 / 2)
        block.updateAttributes()
    }
}
