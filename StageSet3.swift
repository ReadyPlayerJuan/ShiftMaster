//
//  StageSet3.swift
//  coolGame
//
//  Created by Nick Seel on 3/7/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class StageSet3 {
    class func loadStages(base: Stage) {
        let s0 = getStage(index: 0)
        let s1 = getStage(index: 1)
        
        base.addChild(child: s0)
        s0.addChild(child: s1)
        s1.addChild(child: base)
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
            let s = Stage.loadStage(code: "b-9.-9.1.1.1.1.1.1.1.-9.-9,-9.99.0.0.0.0.0.0.0.99.-9,1.0.0.2.3.3.0.0.0.0.1,1.0.0.219.0.0.0.3.3.0.1,1.0.2.0.3.2.2.3.2.0.1,1.0.0.0.3.613.2.0.0.0.1,1.0.3.2.3.3.2.0.3.0.1,1.0.2.2.0.012.0.-11.0.0.1,1.0.0.0.0.2.2.3.0.0.1,-9.99.0.0.0.0.0.0.0.99.-9,-9.-9.1.1.1.1.1.1.1.-9.-9es5.7ex7.7.0emdefaultName")
            s.stageTransitionType = 1
            return s
        case 1:
            return Stage.loadStage(code: "b-9.1.1.1.1.1.1.1.1.1.1.1.-9,1.0.0.0.0.0.0.0.0.0.0.0.1,1.0.0.0.2.2.4.4.-01.0.0.0.1,1.0.0.0.0.4.2.3.0.0.0.0.1,1.0.0.0.0.0.3.0.0.0.0.0.1,1.0.0.3.3.0.219.2.3.4.4.0.1,1.0.4.3.2.714.0.512.3.2.4.0.1,1.0.4.4.2.3.013.0.2.2.0.0.1,1.0.0.0.0.0.2.0.0.0.0.0.1,1.0.0.0.0.2.3.4.0.0.0.0.1,1.0.0.0.0.4.4.3.3.0.0.0.1,1.0.0.0.0.0.0.0.0.0.0.0.1,-9.1.1.1.1.1.1.1.1.1.1.1.-9es6.7ex8.2.0emdefaultName")
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
