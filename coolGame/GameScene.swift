//
//  GameScene.swift
//  another test game
//
//  Created by Erin Seel on 12/3/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var drawNode: SKNode!
    var rotateNode: SKNode!
    var superNode: SKNode!
    var inputNode: SKNode!
    
    static let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.width
    static let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.height
    
    var delta = 0.0
    
    var mainView: SKView!
    var controller: UIViewController!
    var prevTime = 0.0
    
    override func didMove(to view: SKView) {
        mainView = view
        if(GameState.allActions.count == 0) {
            GameState.initGameActions()
        }
        ShadersMaster.initShaders()
        beginGame()
    }
    
    func beginGame() {
        backgroundColor = Board.backgroundColor
        
        
        GameState.gamescene = self
        
        superNode = SKNode.init()
        drawNode = SKNode.init()
        rotateNode = SKNode.init()
        inputNode = SKNode.init()
        inputNode.zPosition = 500
        
        self.shader = PostShaders.invertShader
        self.shouldEnableEffects = true
        
        addChild(superNode)
        superNode.addChild(rotateNode)
        rotateNode.addChild(drawNode)
        
        GameState.drawNode = drawNode
        GameState.rotateNode = rotateNode
        GameState.superNode = superNode
        GameState.inputNode = inputNode
        
        InputController.inputButtonNode = inputNode
        superNode.addChild(inputNode)
        InputController.initElements()
        
        Camera.drawNode = drawNode
        
        /*Player.currentAbilities = [String]()
        Player.maxAbilities = 0
        for _ in 0...Player.allAbilities.count-1 {
            Player.currentAbilities.append(Player.allAbilities[Player.maxAbilities])
            Player.maxAbilities += 1
        }*/
        
        GameState.beginGame()
        GameState.ignoreDelta = true
        GameState.update(delta: 0)
        GameState.ignoreDelta = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputController.touchesBegan(touches, node: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputController.touchesMoved(touches, node: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputController.touchesEnded(touches, node: self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputController.touchesCancelled(touches, node: self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        GameState.update(delta: currentTime - prevTime)
        prevTime = currentTime
    }
}
