//
//  StageSet1.swift
//  coolGame
//
//  Created by Nick Seel on 1/9/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class StageSet2 {
    class func loadStages(base: Stage) {
        let s0 = getStage(index: 0)
        let s1 = getStage(index: 1)
        let s2 = getStage(index: 2)
        let s3 = getStage(index: 3)
        
        base.addChild(child: s0)
        s0.addChild(child: s1)
        s1.addChild(child: s2)
        s2.addChild(child: s3)
        s3.addChild(child: base)
    }
    
    class func getStage(index: Int) -> Stage {
        var stage: [[Int]]? = nil
        var spawnPoint = CGPoint(x: -1, y: -1)
        var otherEntities: [Entity]!
        otherEntities = []
        var exitTargets: [[Int]]!
        var name = "no name found"
        
        /*
         stage writing guide:
         - stage arrays must be rectangular
         - spawnpoint and overlayed entities must be defined after instantiating stage array
         
         - code for block types:
         - 0 is black passable block
         - 1 is white impassable block
         - 2-8 are colored blocks, color is in ColorTheme with index n-2
         - -9 is invisible impassable block, to create illusion of no blocks
         - -AB is end gate, where A-1 is direction and B-2 is colorIndex of surrounding block
         - ABC is color change, where A is direction, B-2 is colorIndex of surrounding block, and c-2 is colorIndex of color change triangle
         - 99 is a hazard block
         */
        
        switch(index) {
        case 0:
            return Stage.loadStage(code: "b-9.-9.1.1.1.1.1.1.1.-9.-9,-9.99.0.0.0.0.0.0.0.99.-9,1.0.0.2.3.3.0.0.0.0.1,1.0.0.219.0.0.0.3.3.0.1,1.0.2.0.3.2.2.3.2.0.1,1.0.0.0.3.613.2.0.0.0.1,1.0.3.2.3.3.2.0.3.0.1,1.0.2.2.0.012.0.-11.0.0.1,1.0.0.0.0.2.2.3.0.0.1,-9.99.0.0.0.0.0.0.0.99.-9,-9.-9.1.1.1.1.1.1.1.-9.-9es5.7ex7.7.0emdefaultName")
            //return Stage.loadStage(code: "b1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1.1,1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.0.-11.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.1.1.1.0.0.0.0.1.0.0.0.0.0.0.0.0.0.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.0.0.0.0.1.0.0.0.0.0.0.0.1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.0.0.0.0.0.0.0.0.1.0.0.0.0.0.1.0.0.0.0.0.1.0.0.1.1.1.0.0.0.0.0.0.1,1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1.0.0.1,1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1.1,1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.1.1.1.0.0.1.1.1.1.0.0.1.0.0.1.1.1.1.0.0.0.1.1.1.1.0.0.0.0.1.1.1.1,-9.-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9.-9,-9.-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9.-9,-9.-9.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.-9.-9es2.10ex2.3.0emdefaultName")
        case 1:
            return Stage.loadStage(code: "b-9.-9.-9.-9.1.1.1.1.1.1.1.1.1.-9.-9.-9.-9,-9.-9.99.99.0.0.0.0.0.0.0.0.0.99.99.-9.-9,-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9,1.0.0.0.1.1.0.0.0.0.0.1.1.0.0.0.1,1.0.0.0.1.0.0.0.1.0.0.0.1.0.0.0.1,1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.0.0.0.0.0.1.0.0.0.1.0.0.0.0.0.1,1.0.-21.1.0.0.1.1.1.1.1.0.0.1.-01.0.1,1.0.0.0.0.0.1.0.0.0.1.0.0.0.0.0.1,1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,1.0.0.0.1.0.0.0.1.0.0.0.1.0.0.0.1,1.0.0.0.1.1.0.0.0.0.0.1.1.0.0.0.1,-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9,-9.-9.99.99.0.0.0.0.0.0.0.0.0.99.99.-9.-9,-9.-9.-9.-9.1.1.1.1.1.1.1.1.1.-9.-9.-9.-9es8.6ex2.7.0,14.7.0emdefaultName")
        case 2:
            return Stage.loadStage(code: "b1.1.1.1.1.1.1.1,1.0.0.0.0.0.0.1,1.0.0.1.0.-11.0.1,1.0.1.0.0.1.0.1,1.0.0.0.0.0.0.1,1.0.0.0.0.0.0.1,1.1.1.1.1.1.1.1es2.5ex5.2.0en0-1.1.4.3en0-1.0.4.2emdefaultName")
        case 3:
            return Stage.loadStage(code: "b-9.-9.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.-9.-9,-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9,99.0.0.3.134.2.2.0.0.0.4.0.0.0.0.0.4.0.0.0.99,99.0.0.0.0.0.3.-02.2.0.0.4.0.0.0.0.4.0.3.0.99,99.0.4.4.4.0.0.0.3.2.0.0.4.0.0.0.4.0.034.0.99,99.0.0.0.0.4.4.0.0.3.2.0.4.0.0.4.0.0.2.0.99,99.0.0.0.0.0.0.4.0.3.2.0.113.4.0.4.0.3.2.0.99,99.0.0.0.0.0.4.4.0.0.3.2.0.4.4.0.0.-32.0.0.99,99.0.0.0.4.4.213.0.0.0.3.2.0.0.0.0.3.2.0.0.99,99.0.0.4.0.0.0.2.2.2.112.2.0.0.3.3.2.0.0.0.99,99.0.4.0.0.2.2.3.3.212.0.012.3.3.2.2.0.0.4.0.99,99.0.0.0.2.3.3.0.0.2.312.2.2.2.0.0.0.4.0.0.99,99.0.0.2.3.0.0.0.0.2.3.0.0.0.013.4.4.0.0.0.99,99.0.0.-12.0.0.4.4.0.2.3.0.0.4.4.0.0.0.0.0.99,99.0.2.3.0.4.0.4.313.0.2.3.0.4.0.0.0.0.0.0.99,99.0.2.0.0.4.0.0.4.0.2.3.0.0.4.4.0.0.0.0.99,99.0.234.0.4.0.0.0.4.0.0.2.3.0.0.0.4.4.4.0.99,99.0.3.0.4.0.0.0.0.4.0.0.2.-22.3.0.0.0.0.0.99,99.0.0.0.4.0.0.0.0.0.4.0.0.0.2.2.334.3.0.0.99,-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9,-9.-9.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.99.-9.-9es10.10ex7.3.0,17.7.0,3.13.0,13.17.0emdefaultName")
        case 4:
            return Stage.loadStage(code: "b-9.-9.-9.-9.-9.-9.-9.-9.99.99.99.99.99.99.99.99.99.-9.-9.-9.-9.-9.-9.-9.-9,-9.-9.-9.-9.-9.-9.99.99.0.0.0.0.0.0.0.0.0.99.99.-9.-9.-9.-9.-9.-9,-9.-9.-9.-9.99.99.0.0.0.0.0.0.0.0.0.0.0.0.0.99.99.-9.-9.-9.-9,-9.-9.-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9.-9.-9,-9.-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9.-9,-9.-9.99.0.0.0.0.0.0.0.3.2.7.7.2.0.0.0.0.0.0.0.99.-9.-9,-9.99.0.0.0.0.0.0.7.4.4.3.2.7.6.2.3.0.0.0.0.0.0.99.-9,-9.99.0.0.0.0.0.3.7.2.253.5.2.3.2.5.4.2.0.0.0.0.0.99.-9,99.0.0.0.0.0.2.2.6.6.0.0.0.0.0.2.5.6.2.0.0.0.0.0.99,99.0.0.0.0.0.7.5.3.0.0.0.0.0.0.0.2.3.5.0.0.0.0.0.99,99.0.0.0.0.7.5.2.0.0.0.0.0.0.0.0.0.7.5.6.0.0.0.0.99,99.0.0.0.0.3.3.4.0.0.0.-21.7.0.0.0.0.4.4.3.0.0.0.0.99,99.0.0.0.0.4.6.5.0.0.0.0.0.0.0.0.0.5.6.3.0.0.0.0.99,99.0.0.0.0.4.3.7.0.0.0.0.6.-01.0.0.0.6.2.5.0.0.0.0.99,99.0.0.0.0.6.5.3.0.0.0.0.0.0.0.0.0.3.4.2.0.0.0.0.99,99.0.0.0.0.0.226.6.4.0.0.0.0.0.0.0.2.5.7.0.0.0.0.0.99,99.0.0.0.0.0.4.2.6.3.0.0.0.0.0.4.5.7.2.0.0.0.0.0.99,-9.99.0.0.0.0.0.7.2.2.2.4.4.2.3.2.5.3.0.0.0.0.0.99.-9,-9.99.0.0.0.0.0.0.2.7.6.3.7.127.6.7.3.0.0.0.0.0.0.99.-9,-9.-9.99.0.0.0.0.0.0.0.6.7.125.3.5.0.0.0.0.0.0.0.99.-9.-9,-9.-9.99.0.0.0.0.0.0.0.0.0.214.0.0.0.0.0.0.0.0.0.99.-9.-9,-9.-9.-9.99.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.99.-9.-9.-9,-9.-9.-9.-9.99.99.0.0.0.0.0.0.0.0.0.0.0.0.0.99.99.-9.-9.-9.-9,-9.-9.-9.-9.-9.-9.99.99.0.0.0.0.0.0.0.0.0.99.99.-9.-9.-9.-9.-9.-9,-9.-9.-9.-9.-9.-9.-9.-9.99.99.99.99.99.99.99.99.99.-9.-9.-9.-9.-9.-9.-9.-9es12.3ex11.11.0,13.13.0ec1mdefaultName")
        default:
            stage =       [ [1, 1, 1, 1, 1],
                            [1, 0, 0, 0, 1],
                            [1, 0, 0, 0, 1],
                            [1, 0, 0,-11,1],
                            [1, 1, 1, 1, 1] ]
            spawnPoint = CGPoint(x: 1, y: 3);
            exitTargets = [[3, 3, 0]]
            name = "default"; break
        }
        
        return Stage.init(withBlocks: stage!, entities: otherEntities, spawn: spawnPoint, withName: name, exits: exitTargets, colorTheme: 0)
    }
}
