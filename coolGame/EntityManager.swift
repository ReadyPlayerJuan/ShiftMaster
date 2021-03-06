//
//  EntityManager.swift
//  another test game
//
//  Created by Nick Seel on 12/10/16.
//  Copyright © 2016 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class EntityManager {
    static var entities: [Entity] = []
    static var entitiesByCollisionPriority: [Entity] = []
    static var particles: [Particle] = []
    static var nextID = 0
    static let collisionRadius = 2.0
    static var collisionIterations = 3
    
    static func addEntity(entity: Entity) {
        entities.append(entity)
        entity.update(delta: 0.0)
    }
    
    static func removeEntity(entity: Entity) {
        for i in 0...entities.count-1 {
            if(entities[i].ID == entity.ID) {
                entities.remove(at: i)
                return
            }
        }
    }
    
    static func addParticle(particle: Particle) {
        particles.append(particle)
        GameState.drawNode.addChild(particle.sprite)
        
    }
    
    static func updateEntities(delta: TimeInterval) {
        /*if let p = (EntityManager.getPlayer()) {
            let vel = hypot(p.xVel, p.yVel)
            if(vel > 1) {
                collisionIterations = Int(vel)+3
            }
        }*/
        collisionIterations = 3
        
        
        for e in entities {
            if(e.isDynamic) {
                e.nearbyEntities = getEntitiesNear(entity: e, radius: collisionRadius)
            }
        }
        
        for _ in 0...collisionIterations-1 {
            for e in entities {
                if(e.isDynamic) {
                    e.update(delta: delta / Double(collisionIterations))
                }
            }
            checkForCollision()
        }
        for e in entities {
            if(!e.isDynamic) {
                e.update(delta: delta)
            }
        }
        
        
        if(particles.count > 0) {
            var i = 0
            while(i < particles.count) {
                particles[i].update(delta: delta)
                if(!particles[i].isAlive()) {
                    particles[i].sprite.removeFromParent()
                    particles.remove(at: i)
                    i -= 1
                }
                i += 1
            }
        }
        
        updateEntityAttributes()
    }
    
    static func updateEntityAttributes() {
        for e in entities {
            e.updateAttributes()
        }
    }
    
    static func checkForCollision() {
        for e in entitiesByCollisionPriority {
            if(e.isDynamic) {
                e.checkForCollision()
            }
        }
        
        moveEntities()
    }
    
    static func moveEntities() {
        for e in entities {
            if(e.isDynamic) {
                e.move()
            }
        }
    }
    
    static func gameActionFirstFrame(_ action: GameAction) {
        for e in entities {
            e.gameActionFirstFrame(action)
        }
    }
    
    static func gameActionLastFrame(_ action: GameAction) {
        for e in entities {
            e.gameActionLastFrame(action)
        }
    }
    
    static func redrawEntities(node: SKNode, name: String) {
        if(name == "all") {
            if(node.children.count != 0) {
                for sprite in node.children {
                    sprite.removeFromParent()
                }
            }
            
            for e in entities {
                node.addChild(e.sprite)
            }
            
            
            for p in particles {
                p.sprite.removeFromParent()
                node.addChild(p.sprite)
            }
        } else if(name == "player") {
            node.addChild(EntityManager.getPlayer()!.sprite)
        }
    }
    /*
    static func reloadBlocks() {
        var temp = [Entity]()
        for e in entities {
            if(e.name != "block") {
                temp.append(e)
            }
        }
        entities = temp
        
        for row in 0 ... Board.blocks.count-1 {
            for col in 0 ... Board.blocks[0].count-1 {
                addEntity(entity: Board.blocks[row][col]!)
            }
        }
    }*/
    
    static func reloadAllEntities() {
        for e in entities {
            e.removeSpriteFromParent()
            e.load()
        }
        redrawEntities(node: GameState.drawNode, name: "all")
    }
    
    static func getEntitiesNear(entity: Entity, radius: Double) -> [Entity] {
        var temp = [Entity]()
        
        for e in entities {
            if(!e.isInactive && hypot(e.x - entity.x, e.y - entity.y) <= radius
                    && e.ID != entity.ID && entity.collisionPriority <= e.collisionPriority) {
                temp.append(e)
            }
        }
        
        return temp
    }
    
    static func sortEntities() {
        entitiesByCollisionPriority = sortEntitiesByCollisionPriority()
    }
    
    static func sortEntitiesByCollisionPriority() -> [Entity] {
        var temp = [Entity]()
        
        for e in entities {
            var index = 0
            if(temp.count > 0) {
                while(index < temp.count && temp[index].collisionPriority > e.collisionPriority) {
                    index += 1
                }
            }
            
            temp.insert(e, at: index)
        }
        
        return temp
    }
    
    static func getPlayer() -> Entity? {
        for e in entities {
            if(e.controllable) {
                return e
            }
        }
        print("no player found")
        return nil
    }
    /*
    static func loadLightSources() {
        for e in entities {
            if(e.name == "light source") {
                (e as! LightSource).loadStageInfo()
            }
        }
    }*/
    
    static func getID() -> Int {
        nextID += 1
        return nextID
    }
}
