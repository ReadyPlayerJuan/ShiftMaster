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
    var inputNode: SKNode!
    
    static let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.width
    static let screenWidth = UIScreen.main.fixedCoordinateSpace.bounds.height
    
    var delta = 0.0
    
    var mainView: SKView!
    var controller: MenuViewController!
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
        
        GameState.editorscene = self
        EditorManager.editorScene = self
        
        superNode = SKNode.init()
        drawNode = SKNode.init()
        rotateNode = SKNode.init()
        editorNode = SKNode.init()
        editorNode.zPosition = 0//600
        inputNode = SKNode.init()
        inputNode.zPosition = 500
        
        removeAllChildren()
        addChild(superNode)
        superNode.addChild(rotateNode)
        superNode.addChild(editorNode)
        rotateNode.addChild(drawNode)
        
        /*var prev: SKNode = superNode
        for i in 0...100 {
            let a = SKSpriteNode.init(color: UIColor.red, size: CGSize(width: 100, height: 100))
            a.position.x = CGFloat(i)
            prev.addChild(a)
            prev = a
        }*/
        
        EditorManager.drawNode = editorNode
        
        GameState.drawNode = drawNode
        GameState.rotateNode = rotateNode
        GameState.superNode = superNode
        GameState.inputNode = inputNode
        
        InputController.inputButtonNode = inputNode
        superNode.addChild(inputNode)
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
        
        GameState.beginGame()
        EditorManager.initElements()
        GameState.ignoreDelta = true
        GameState.update(delta: 0)
        GameState.ignoreDelta = true
        
        GameState.gameAction(GameAction.editing)
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
