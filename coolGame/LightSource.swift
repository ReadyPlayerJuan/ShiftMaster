//
//  LightSource.swift
//  coolGame
//
//  Created by Nick Seel on 2/12/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit
/*
class LightSource: Entity {
    var blockTransparency: [[Bool]] = [[]]
    var stageEdges: [LineSegment] = []
    var lightingSegments: [LineSegment] = []
    var type: Int = 0
    
    var onPlayer: Bool = false
    var source: Entity? = nil
    
    var minEdgeY: Int!
    var maxEdgeY: Int!
    var minEdgeX: Int!
    var maxEdgeX: Int!
    
    init(xPos: Double, yPos: Double, onPlayer: Bool) {
        super.init()
        
        self.onPlayer = onPlayer
        x = xPos
        y = yPos
        
        minEdgeY = Int(y - (Double(GameState.screenHeight/2) / Board.blockSize) - 1)
        maxEdgeY = Int(y + (Double(GameState.screenHeight/2) / Board.blockSize) + 1)
        minEdgeX = Int(x - (Double(GameState.screenWidth/2) / Board.blockSize) - 1)
        maxEdgeX = Int(x + (Double(GameState.screenWidth/2) / Board.blockSize) + 1)
        
        name = "light source"
        isDynamic = false
        collisionPriority = 0
        zPos = 15
        
        collidesWithType = [0, 10, 11, 12, 13, 14, 15]
        collisionType = 0
        
        loadSprite()
    }
    
    init(colorSource: Entity, xPos: Double, yPos: Double) {
        super.init()
        
        source = colorSource
        x = xPos
        y = yPos
        
        minEdgeY = Int(y - (Double(GameState.screenHeight/2) / Board.blockSize) - 1)
        maxEdgeY = Int(y + (Double(GameState.screenHeight/2) / Board.blockSize) + 1)
        minEdgeX = Int(x - (Double(GameState.screenWidth/2) / Board.blockSize) - 1)
        maxEdgeX = Int(x + (Double(GameState.screenWidth/2) / Board.blockSize) + 1)
        
        name = "light source"
        isDynamic = false
        collisionPriority = 0
        zPos = 15
        
        collidesWithType = [0, 10, 11, 12, 13, 14, 15]
        collisionType = 0
        
        loadSprite()
    }
    
    override func duplicate() -> Entity {
        if(source == nil) {
            return LightSource.init(xPos: x, yPos: y, onPlayer: onPlayer)
        }
        return LightSource.init(colorSource: source!, xPos: x, yPos: y)
    }
    
    override func update(delta: TimeInterval) {
        updateSprite()
    }
    
    func getAngle(from: CGPoint, to: CGPoint) -> CGFloat {
        var a = atan( (from.y - to.y) / (from.x - to.x) )
        if(to.x < from.x) {
            a += (3.14159)
        }
        if(a < 0) {
            a += (3.14159*2)
        }
        return a
    }
    
    func anglesNear(_ a: CGFloat, _ b: CGFloat) -> Bool {
        var c = (a + (3.14159*8))
        var d = (b + (3.14159*8))
        while(c > (3.14159*2)) {
            c -= (3.14159*2)
        }
        while(d > (3.14159*2)) {
            d -= (3.14159*2)
        }
        return abs(c-d) < 3.14159
    }
    
    func findNearestCollision(center: CGPoint, angle: CGFloat) -> LineSegment? {
        var currentPoint = center
        let slope = CGFloat(tan(angle))
        
        
        for _ in 0...100 {
            var xDistance: CGFloat, yDistance: CGFloat
            
            if(cos(angle) > 0) {
                xDistance = (CGFloat(Int(currentPoint.x+1)) - currentPoint.x)
            } else {
                xDistance = (CGFloat(Int(currentPoint.x+0)) - currentPoint.x)
            }
            if(xDistance == 0) {
                if(cos(angle) > 0) {
                    xDistance += 1
                } else {
                    xDistance -= 1
                }
            }
            
            if(sin(angle) > 0) {
                yDistance = (CGFloat(Int(currentPoint.y+1)) - currentPoint.y)
            } else {
                yDistance = (CGFloat(Int(currentPoint.y+0)) - currentPoint.y)
            }
            if(yDistance == 0) {
                if(sin(angle) > 0) {
                    yDistance += 1
                } else {
                    yDistance -= 1
                }
            }
            
            let offscreen = false
            //var skip = false
            /*if(currentPoint.x > CGFloat(maxEdgeX) || currentPoint.x < CGFloat(minEdgeX) || currentPoint.y < CGFloat(minEdgeY) || currentPoint.y > CGFloat(maxEdgeY)) {
                offscreen = true
            }*/
            
            if(abs(xDistance * slope) < abs(yDistance)) {
                currentPoint.x += xDistance
                currentPoint.y += xDistance * slope
                
                if(currentPoint.x >= 0 && currentPoint.x < CGFloat(blockTransparency[0].count) &&
                    currentPoint.y >= 0 && currentPoint.y < CGFloat(blockTransparency.count)) {
                    
                    if((blockTransparency[Int(currentPoint.y+1)][Int(currentPoint.x-0)] && !(Int(currentPoint.y+1) == Int(y) && Int(currentPoint.x+0) == Int(x))) || (blockTransparency[Int(currentPoint.y+1)][Int(currentPoint.x-1)] && !(Int(currentPoint.y+1) == Int(y) && Int(currentPoint.x-1) == Int(x))) || offscreen) {
                        return LineSegment.init(CGPoint.init(x: Int(currentPoint.x), y: Int(currentPoint.y+1)), CGPoint.init(x: Int(currentPoint.x), y: Int(currentPoint.y)))
                    }
                }
            } else {
                currentPoint.x += yDistance / slope
                currentPoint.y += yDistance
                
                if(currentPoint.x >= 0 && currentPoint.x < CGFloat(blockTransparency[0].count) &&
                    currentPoint.y >= 0 && currentPoint.y < CGFloat(blockTransparency.count)) {
                    
                    if((blockTransparency[Int(currentPoint.y)][Int(currentPoint.x)] && !(Int(currentPoint.y+0) == Int(y) && Int(currentPoint.x+0) == Int(x))) || (blockTransparency[Int(currentPoint.y+1)][Int(currentPoint.x)] && !(Int(currentPoint.y+1) == Int(y) && Int(currentPoint.x+0) == Int(x))) || offscreen) {
                        return LineSegment.init(CGPoint.init(x: Int(currentPoint.x), y: Int(currentPoint.y)), CGPoint.init(x: Int(currentPoint.x+1), y: Int(currentPoint.y)))
                    }
                }
            }
        }
        return nil
    }
    
    override func updateSprite() {
        if(!(GameState.state == "stage transition" && !GameState.enteringStage) && !(GameState.playerState == "changing color" && GameState.endingStage)) {
            
            var center = CGPoint()
            if(!onPlayer) {
                center = CGPoint(x: x+0.5, y: y-0.5)
            } else {
                let player = EntityManager.getPlayer() as! Player
                center = CGPoint(x: player.x + 0.5, y: player.y - 0.5)
                
                minEdgeY = Int(center.y - ((GameState.screenHeight/2) / CGFloat(Board.blockSize)) - 1)
                maxEdgeY = Int(center.y + ((GameState.screenHeight/2) / CGFloat(Board.blockSize)) + 1)
                minEdgeX = Int(center.x - ((GameState.screenWidth/2) / CGFloat(Board.blockSize)) - 1)
                maxEdgeX = Int(center.x + ((GameState.screenWidth/2) / CGFloat(Board.blockSize)) + 1)
            }
            
            
            if(stageEdges.count > 10 && (onPlayer || lightingSegments.count == 0)) {
                loadLighting(center: center, from: 0, to: (3.14159*2))
                drawLighting(center: center)
            } else if(source != nil) {
                if(source!.name == "block" && (source as! Block).type == 6) {
                    drawLighting(center: center)
                }
            }
        } else {
            sprite.removeAllChildren()
        }
    }
    
    private func drawLighting(center: CGPoint) {
        sprite.removeAllChildren()
        
        let size = CGFloat(Board.blockSize)
        var s: SKShapeNode
        
        
        for ls in lightingSegments {
            let b = UIBezierPath.init()
            b.move(to: CGPoint(x: center.x * size, y: -center.y * size))
            b.addLine(to: CGPoint(x: ls.points[0].x * size, y: -ls.points[0].y * size))
            b.addLine(to: CGPoint(x: ls.points[1].x * size, y: -ls.points[1].y * size))
            
            s = SKShapeNode.init(path: b.cgPath)
            
            if(source == nil) {
                if(GameState.inverted) {
                    s.fillColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
                } else {
                    s.fillColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
                }
            } else {
                let color = source!.sprite.fillColor.cgColor.components!
                s.fillColor = UIColor.init(red: color[0], green: color[1], blue: color[2], alpha: 0.2)
            }
            s.alpha = 0.2
            s.strokeColor = UIColor.clear
            //s.blendMode = SKBlendMode.alpha
            sprite.addChild(s.copy() as! SKShapeNode)
        }
    }
    
    private func loadLighting(center: CGPoint, from startAngle: Double, to endAngle: Double) {
        var confirmedSegments = [LineSegment]()
        
        var checkAngle = CGFloat(startAngle)
        var numLoopsA = 0
        var completed = false
        
        
        var firstSegment: LineSegment? = nil
        var firstSegmentPoint: CGPoint? = nil
        let finalSegment: LineSegment? = findNearestCollision(center: center, angle: CGFloat(endAngle+0.00001))
        var finalSegmentPoint: CGPoint? = nil
        
        if(finalSegment != nil) {
            if(finalSegment!.vertical) {
                finalSegmentPoint = CGPoint.init(x: finalSegment!.points[0].x, y: getIntersectPosition(finalSegment!, with: LineSegment.init(center, CGPoint.init(x: center.x + cos(CGFloat(endAngle)), y: center.y + sin(CGFloat(endAngle))))))
            } else {
                finalSegmentPoint = CGPoint.init(x: getIntersectPosition(finalSegment!, with: LineSegment.init(center, CGPoint.init(x: center.x + cos(CGFloat(endAngle)), y: center.y + sin(CGFloat(endAngle))))), y: finalSegment!.points[0].y)
            }
        }
        
        
        
        while(numLoopsA < 100 && !completed) {
            numLoopsA += 1
            
            //find nearest collision at checkAngle
            var nearestCollision: LineSegment? = nil
            var nearestCollisionStartPoint: CGPoint? = nil
            
            
            nearestCollision = findNearestCollision(center: center, angle: checkAngle+0.00001)
            
            if(nearestCollision != nil) {
                if(nearestCollision!.vertical) {
                    nearestCollisionStartPoint = CGPoint.init(x: nearestCollision!.points[0].x, y: getIntersectPosition(nearestCollision!, with: LineSegment.init(center, CGPoint.init(x: center.x + cos(checkAngle), y: center.y + sin(checkAngle)))))
                } else {
                    nearestCollisionStartPoint = CGPoint.init(x: getIntersectPosition(nearestCollision!, with: LineSegment.init(center, CGPoint.init(x: center.x + cos(checkAngle), y: center.y + sin(checkAngle)))), y: nearestCollision!.points[0].y)
                }
                if(firstSegment == nil) {
                    firstSegment = nearestCollision!
                    firstSegmentPoint = nearestCollisionStartPoint!
                    
                    if(firstSegment!.equals(finalSegment!) && abs(startAngle-endAngle) < 3.14159) {
                        confirmedSegments.append(LineSegment.init(firstSegmentPoint!, finalSegmentPoint!))
                        completed = true
                    }
                }
                
                
                var point: CGPoint!
                
                //set point to the most rotated point on the collided edge
                var angle0 = getAngle(from: center, to: nearestCollision!.points[0])
                var angle1 = getAngle(from: center, to: nearestCollision!.points[1])
                if(abs(angle0 - angle1) > 3.14159) {
                    if(angle0 < angle1) {
                        angle0 += (3.14159*2)
                    } else {
                        angle1 += (3.14159*2)
                    }
                }
                if(angle0 > angle1) {
                    point = nearestCollision!.points[0]
                } else {
                    point = nearestCollision!.points[1]
                }
                
                let maxAngle = getAngle(from: center, to: point)
                checkAngle = maxAngle
                
                
                
                var finished = false
                var numLoops = 0
                
                while(!completed && !finished && numLoops < 100) {
                    numLoops += 1
                    
                    var checkAngleSegment: LineSegment? = nil
                    var nextCollision: LineSegment? = nil
                    
                    nextCollision = findNearestCollision(center: center, angle: checkAngle-0.00001)
                    checkAngleSegment = LineSegment.init(center, CGPoint.init(x: center.x + cos(checkAngle-0.00001), y: center.y + sin(checkAngle-0.00001)))
                    
                    
                    if(nextCollision == nil) {
                        
                    } else if(nextCollision!.equals(nearestCollision!)) {
                        finished = true
                        
                        if(nextCollision!.equals(firstSegment!) && numLoopsA > 1) {
                            checkAngle = 0
                            completed = true
                            if(nearestCollision!.vertical) {
                                confirmedSegments.append(LineSegment.init(nearestCollisionStartPoint!, firstSegmentPoint!))
                            } else {
                                confirmedSegments.append(LineSegment.init(nearestCollisionStartPoint!, firstSegmentPoint!))
                            }
                        } else if(nextCollision!.equals(finalSegment!) && numLoopsA > 1) {
                            checkAngle = 0
                            completed = true
                            if(nearestCollision!.vertical) {
                                confirmedSegments.append(LineSegment.init(nearestCollisionStartPoint!, finalSegmentPoint!))
                            } else {
                                confirmedSegments.append(LineSegment.init(nearestCollisionStartPoint!, finalSegmentPoint!))
                            }
                        } else {
                            checkAngle = maxAngle
                            if(nearestCollision!.vertical) {
                                confirmedSegments.append(LineSegment.init(nearestCollisionStartPoint!, CGPoint.init(x: nearestCollisionStartPoint!.x, y: getIntersectPosition(nearestCollision!, with: checkAngleSegment!))))
                            } else {
                                confirmedSegments.append(LineSegment.init(nearestCollisionStartPoint!, CGPoint.init(x: getIntersectPosition(nearestCollision!, with: checkAngleSegment!), y: nearestCollisionStartPoint!.y)))
                            }
                        }
                    } else {
                        var point2: CGPoint!
                        
                        var angle0 = getAngle(from: center, to: nextCollision!.points[0])
                        var angle1 = getAngle(from: center, to: nextCollision!.points[1])
                        if(abs(angle0 - angle1) > 3.14159) {
                            if(angle0 < angle1) {
                                angle0 += (3.14159*2)
                            } else {
                                angle1 += (3.14159*2)
                            }
                        }
                        if(angle0 > angle1) {
                            point2 = nextCollision!.points[1]
                        } else {
                            point2 = nextCollision!.points[0]
                        }
                        checkAngle = getAngle(from: center, to: point2)
                        
                        
                        if(nextCollision!.vertical) {
                            confirmedSegments.append(LineSegment.init(point2, CGPoint.init(x: point2.x, y: getIntersectPosition(nextCollision!, with: checkAngleSegment!))))
                        } else {
                            confirmedSegments.append(LineSegment.init(point2, CGPoint.init(x: getIntersectPosition(nextCollision!, with: checkAngleSegment!), y: point2.y)))
                        }
                    }
                }
                if(numLoops >= 99) {
                    let player = EntityManager.getPlayer()!
                    print("loop failed", player.x)
                    
                    if(player.xVel > 0) {
                        player.x -= 0.001
                    } else if(player.xVel < 0) {
                        player.x += 0.001
                    }
                    player.nextX = x
                }
            }
        }
        
        lightingSegments = confirmedSegments
    }
    
    private func linesIntersect(_ this: LineSegment, with: LineSegment) -> Bool {
        if(this.vertical) {
            let slope = (with.points[1].y - with.points[0].y) / ((with.points[1].x - with.points[0].x)+0.00001)
            let yPos = (slope * (this.points[0].x - with.points[0].x)) + with.points[0].y
            return ((yPos > this.points[0].y && yPos < this.points[1].y) || (yPos < this.points[0].y && yPos > this.points[1].y))
        } else {
            let slope = (with.points[1].x - with.points[0].x) / ((with.points[1].y - with.points[0].y)+0.00001)
            let xPos = (slope * (this.points[0].y - with.points[0].y)) + with.points[0].x
            return ((xPos > this.points[0].x && xPos < this.points[1].x) || (xPos < this.points[0].x && xPos > this.points[1].x))
        }
    }
    
    private func getIntersectPosition( _ this: LineSegment, with: LineSegment) -> CGFloat {
        if(this.vertical) {
            let slope = (with.points[1].y - with.points[0].y) / ((with.points[1].x - with.points[0].x)+0.00001)
            let yPos = (slope * (this.points[0].x - with.points[0].x)) + with.points[0].y
            return yPos
        } else {
            let slope = (with.points[1].x - with.points[0].x) / ((with.points[1].y - with.points[0].y)+0.00001)
            let xPos = (slope * (this.points[0].y - with.points[0].y)) + with.points[0].x
            return xPos
        }
    }
    
    override func loadSprite() {
        sprite.zPosition = zPos
    }
    
    func blockIsValid(_ b: Block) -> Bool {
        if(type == 0) {
            return Entity.collides(this: self, with: b)
        } else if(type == 1) {
            return Entity.collides(this: EntityManager.getPlayer()!, with: b)
        } else {
            return false
        }
    }
    
    func loadStageInfo() {
        let width = Board.blocks[0].count
        let height = Board.blocks.count
        blockTransparency = newEmptyBoolArray(width: width, height: height)
        stageEdges = []
        
        for row in 0...Board.blocks.count-1 {
            for col in 0...Board.blocks[0].count-1 {
                blockTransparency[row][col] = blockIsValid(Board.blocks[row][col]!)
            }
        }
        
        for row in 0...blockTransparency.count-1 {
            for col in 0...blockTransparency[0].count-1 {
                if(blockTransparency[row][col] == true) {
                    if(row > 0 && (blockTransparency[row-1][col] == false)) {
                        stageEdges.append(LineSegment.init(CGPoint(x: col, y: row-1), CGPoint(x: col+1, y: row-1)))
                    }
                    if(col > 0 && (blockTransparency[row][col-1] == false)) {
                        stageEdges.append(LineSegment.init(CGPoint(x: col, y: row), CGPoint(x: col, y: row-1)))
                    }
                    if(row < blockTransparency.count-1 && (blockTransparency[row+1][col] == false)) {
                        stageEdges.append(LineSegment.init(CGPoint(x: col, y: row), CGPoint(x: col+1, y: row)))
                    }
                    if(col < blockTransparency[0].count-1 && (blockTransparency[row][col+1] == false)) {
                        stageEdges.append(LineSegment.init(CGPoint(x: col+1, y: row), CGPoint(x: col+1, y: row-1)))
                    }
                }
            }
        }
    }
    
    private func newEmptyBoolArray(width: Int, height: Int) -> [[Bool]] {
        var temp = [[Bool]]()
        for row in 0 ... height-1 {
            temp.append([Bool]())
            for col in 0 ... width-1 {
                if(col != -69) {
                    temp[row].append(false)
                }
            }
        }
        return temp
    }
}*/
