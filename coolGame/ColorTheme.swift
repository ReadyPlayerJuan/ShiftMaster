//
//  ColorTheme.swift
//  Drawing Test
//
//  Created by Erin Seel on 11/25/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class ColorTheme {
    static let colors =
        [ [ [255,0,  0],  [255,127, 0],  [255,255,0],  [0,  255,0],  [0,  0,  255],[255,0,  255] ],
          [ [180,50, 180],[50, 180, 180],[180,80, 50], [80, 0,  180],[0,  180,80], [180, 0, 80]  ] ]
    
    class func getColor(colorIndex: Int, colorVariation: Bool) -> UIColor {
        var colorVar = 0.0
        if(colorVariation) {
            colorVar = Board.colorVariation
        }
        
        let blockVariation = Int((rand()*colorVar*2)-colorVar)
        var colorArray = ColorTheme.colors[Board.colorTheme][colorIndex]
        
        for index in 0 ... 2 {
            colorArray[index] = max(min(colorArray[index] + blockVariation, 255), 0)
        }
        
        return UIColor(red: CGFloat(colorArray[0]) / 255.0, green: CGFloat(colorArray[1]) / 255.0, blue: CGFloat(colorArray[2]) / 255.0, alpha: 1.0)
    }
    
    class func getGrayscaleColor(black: Bool, colorVariation: Bool) -> UIColor {
        var colorVar = 0.0
        if(colorVariation) {
            colorVar = Board.grayVariation
        }
        
        if(black) {
            let blockVariation = Int(rand()*colorVar)
            return UIColor(red: 0.0+(CGFloat(blockVariation)/255.0), green: 0.0+(CGFloat(blockVariation)/255.0), blue: 0.0+(CGFloat(blockVariation)/255.0), alpha: 1.0)
        } else {
            let blockVariation = Int(rand()*colorVar)
            return UIColor(red: 1.0-(CGFloat(blockVariation)/255.0), green: 1.0-(CGFloat(blockVariation)/255.0), blue: 1.0-(CGFloat(blockVariation)/255.0), alpha: 1.0)
        }
    }
    
    private class func rand() -> Double {
        return Double(arc4random())/(pow(2.0, 32.0))
    }
}
