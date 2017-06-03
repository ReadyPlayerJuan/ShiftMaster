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

class EditorScene: SKScene {
    
    var drawNode: SKNode!
    var rotateNode: SKNode!
    var superNode: SKNode!
    var editorNode: SKNode!
    
    static let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.width
    static let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.height
    
    var delta = 0.0
    
    var mainView: SKView!
    var controller: MenuViewController!
    var prevTime = 0.0
    
    override func didMove(to view: SKView) {
        mainView = view
        beginGame()
        
        //UIPasteboard.general.string = "Hello world"
    }
    
    func beginGame() {
        backgroundColor = Board.backgroundColor
        
        //configure main layer
        /*
         rotateLayer = CALayer()
         drawLayer = CALayer()
         
         rotateLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
         rotateLayer.position = CGPoint(x: GameScene.screenWidth/2.0, y: GameScene.screenHeight/2.0)
         rotateLayer.bounds = CGRect(x: 0.0, y: 0.0, width: GameScene.screenWidth, height: GameScene.screenHeight)
         mainView.layer.addSublayer(rotateLayer)
         
         rotateLayer.addSublayer(drawLayer)
         
         GameState.gamescene = self
         GameState.drawLayer = drawLayer
         GameState.rotateLayer = rotateLayer*/
        
        GameState.editorscene = self
        //EditorManager.editorScene = self
        
        superNode = SKNode.init()
        drawNode = SKNode.init()
        rotateNode = SKNode.init()
        editorNode = SKNode.init()
        
        removeAllChildren()
        addChild(superNode)
        superNode.addChild(rotateNode)
        superNode.addChild(editorNode)
        rotateNode.addChild(drawNode)
        
        //EditorManager.drawNode = editorNode
        
        GameState.drawNode = drawNode
        GameState.rotateNode = rotateNode
        GameState.superNode = superNode
        
        InputController.inputButtonNode = superNode
        InputController.initElements()
        
        Camera.drawNode = drawNode
        
        /*if(Player.maxAbilities == 0) {
            Player.currentAbilities = [String]()
            for _ in 0...Player.allAbilities.count-1 {
                Player.currentAbilities.append(Player.allAbilities[Player.maxAbilities])
                Player.maxAbilities += 1
            }
        }*/
        
        if(Memory.getStageEdit() == "no stage") {
            Memory.saveStageEdit(code: Stage.defaultStage)
        }
        
        GameState.ignoreDelta = true
        //GameState.gameAction(type: "begin editor")
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
