//
//  PlayerColorChangeEffect.swift
//  coolGame
//
//  Created by Nick Seel on 1/12/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

extension Player {
    func loadDeathEffect() {
        horizontalMovementTimer = 0
        verticalMovementTimer = 0
        
        respawnEffect = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: 0, y: 0), rotation: 0.0, size: Double(Board.blockSize)))
        respawnEffect.fillColor = UIColor.white
        respawnEffect.strokeColor = UIColor.clear
        respawnEffect.position = CGPoint(x: CGFloat(Board.blockSize)*(Board.spawnPoint.x - CGFloat(x) - 0.5), y: CGFloat(Board.blockSize)*(-Board.spawnPoint.y + CGFloat(y) - 0.5))
        respawnEffect.alpha = 1.0
        sprite.addChild(respawnEffect)
        
        let numTriangles = 4
        let size = (Double(Board.blockSize) / Double(numTriangles)) + 0.0
        
        let startingRotation = 0.2
        let startingVel = 1.0
        
        let diff = 0.1
        let s = SKShapeNode.init(path: getTrianglePath(corner: CGPoint(x: -diff - (size/2.0), y: -(size/2.0)*(sqrt(3.0)/2.0)), rotation: 0.0, size: size + 2*diff))
        s.strokeColor = UIColor.clear
        s.fillColor = deathParticleColor
        //deathParticleColor = defaultSpriteColor
        s.alpha = 1.0
        s.zPosition = 1
        
        deathParticleInfo = []
        deathParticles = []
        
        var rotations: [Double] = []
        switch(preDeathDirection) {
        case 0:
            rotations = [0.0, 3.14159]
            break
        case 1:
            rotations = [3.14159 * (0.5), 3.14159 * (1.5)]
            break
        case 2:
            rotations = [3.14159, 0.0]
            break
        case 3:
            rotations = [3.14159 * (1.5), 3.14159 * (0.5)]
            break
        default: break
        }
        
        for ty in stride(from: 0, to: numTriangles, by: 1) {
            s.zRotation = CGFloat(rotations[0])
            for tx in stride(from: 0, to: numTriangles-ty, by: 1) {
                let px = (Double(tx) + Double(ty)/2.0 + 0.5)*size
                let py = (Double(ty) + 0.5)*size*(sqrt(3.0)/2.0)
                s.position = getDeathParticlePosition(px: px, py: py)
                let sp = s.copy() as! SKShapeNode
                sprite.addChild(sp)
                deathParticles.append(sp)
            }
            
            s.zRotation = CGFloat(rotations[1])
            for tx in stride(from: 0, to: numTriangles-ty-1, by: 1) {
                let px = (Double(tx) + 1.0 + (Double(ty)/2.0))*size
                let py = (Double(ty) + 0.5)*size*(sqrt(3.0)/2.0)
                s.position = getDeathParticlePosition(px: px, py: py)
                let sp = s.copy() as! SKShapeNode
                sprite.addChild(sp)
                deathParticles.append(sp)
            }
        }
        
        let center = CGPoint(x: Double(Board.blockSize) / 2.0, y: Double(Board.blockSize) * (sqrt(3.0)/4.0))
        for p in deathParticles {
            var angle = atan(Double((center.y - p.position.y) / (center.x - p.position.x)))
            if(p.position.x <= center.x) {
                angle += (3.14159)
            }
            p.name = "\(angle)"
            //deathParticleInfo.append([startingVel * cos(angle), startingVel * sin(angle)])
            //p.zRotation = CGFloat(angle)
        }
        
        var temp: [SKShapeNode] = []
        for p in deathParticles {
            var index = 0
            if(temp.count > 0) {
                while(index < temp.count && temp[index].name!.toDouble()! > p.name!.toDouble()!) {
                    index += 1
                }
            }
            
            temp.insert(p, at: index)
        }
        deathParticles = temp
        
        var index = 0
        for _ in deathParticles {
            var angle = (Double(index)*(-2.0*3.14159)/Double(deathParticles.count)) + (3.14159 * (3.0 / 2.0)) + ((0.5-rand())*(3.14159 / 8))
            angle += ((rand() * 0.6) - 0.3) * 3.14159
            deathParticleInfo.append([startingVel * cos(angle), startingVel * sin(angle), ((2.0*rand())-1)*startingRotation, (rand() * 0.3) + 0.3, -1])
            index += 1
        }
    }
    
    private func getDeathParticlePosition(px: Double, py: Double) -> CGPoint {
        var p = CGPoint()
        let blockSize = Double(Board.blockSize)
        
        switch(preDeathDirection) {
        case 0:
            p = CGPoint(x: px, y: py)
            break
        case 1:
            p = CGPoint(x: blockSize*((floor(py/blockSize))+(1-mod(py/blockSize, 1))), y: px)
            break
        case 2:
            p = CGPoint(x: px, y: blockSize*((floor(py/blockSize))+(1-mod(py/blockSize, 1))))
            break
        case 3:
            p = CGPoint(x: py, y: px)
            break
        default: break
        }
        
        return CGPoint(x: p.x - CGFloat(Board.blockSize / 2), y: p.y - CGFloat(Board.blockSize / 2))
    }
    
    func updateDeathEffect(pct: Double) {
        let time = pct
        let blockSize = Double(Board.blockSize)
        
        if(deathParticles.count > 0) {
            for i in 0...deathParticles.count-1 {
                if(deathParticleInfo[i][4] == -1) {
                    if(time < deathParticleInfo[i][3]) {
                        let velMod = 1-(time/deathParticleInfo[i][3])
                        let a = deathParticleInfo[i]
                        let prevPoint = deathParticles[i].position
                        deathParticles[i].position = CGPoint(x: prevPoint.x + CGFloat(a[0]*velMod), y: prevPoint.y + CGFloat(a[1]*velMod))
                        deathParticles[i].zRotation += CGFloat(deathParticleInfo[i][2]*velMod)
                        deathParticles[i].alpha = CGFloat(velMod)
                    } else {
                        let p = deathParticles[i]
                        let target = CGPoint(x: -x + Double(Board.spawnPoint!.x), y: y - Double(Board.spawnPoint!.y) - (0.5 - (sqrt(3) / 6)))
                        
                        deathParticleInfo[i] = [Double(target.x + 0.0)*blockSize, Double(target.y + 0.0)*blockSize, time * -1 + (3.14159 * Double(Int(rand() * 2))), deathParticleInfo[i][3], 42069, (rand() * 0.5) + 0.75,  Double(p.position.y), (rand() * 0.1) + 0.05]
                    }
                } else {
                    let info = deathParticleInfo[i]
                    let progress = min((time - info[3]) / (1 - info[3] - info[7]), 1)
                    let progress2 = pow(progress, 2)
                    let angle = deathParticleInfo[i][2] + (progress2 * 7)
                    let xPos = deathParticleInfo[i][0] + ((1 - progress) * Board.blockSize * deathParticleInfo[i][5] * 2.0 * cos(angle))
                    let yPos = deathParticleInfo[i][1] + ((1 - progress) * Board.blockSize * deathParticleInfo[i][5] * 2.0 * sin(angle))
                    deathParticles[i].position = CGPoint(x: xPos, y: yPos)
                    deathParticles[i].zRotation += CGFloat(progress / 4)
                    
                    //let prog2 = min(1, progress * 1.3)
                    deathParticles[i].fillColor = UIColor.white
                    deathParticles[i].alpha = CGFloat((1 - progress) * progress * 4)
                }
            }
        }
        
        let showTime = 0.2
        var t = time - 1 + showTime
        t = max(0, t)
        t = t / showTime
        respawnEffect.alpha = CGFloat(t)
    }
    
    func mod(_ a: Double, _ b: Double) -> Double {
        var temp = a
        while(temp-b > 0) {
            temp -= b
        }
        return temp
    }
    
    func floor(_ a: Double) -> Double {
        return Double(Int(a))
    }
}
