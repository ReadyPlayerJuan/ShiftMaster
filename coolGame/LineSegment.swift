//
//  LineSegment.swift
//  coolGame
//
//  Created by Nick Seel on 2/12/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import SpriteKit

class LineSegment {
    var points: [CGPoint]
    var vertical = false
    var info: Double
    var distance: CGFloat
    var maxX: CGFloat, maxY: CGFloat, minX: CGFloat, minY: CGFloat
    
    init(_ p1: CGPoint, _ p2: CGPoint) {
        points = [p1, p2]
        vertical = (p1.x == p2.x)
        info = 999
        distance = hypot(p1.y-p2.y, p1.x-p2.x)
        
        maxX = max(p1.x, p2.x)
        maxY = max(p1.y, p2.y)
        minX = min(p1.x, p2.x)
        minY = min(p1.y, p2.y)
    }
    
    func copy() -> LineSegment {
        let ls = LineSegment.init(CGPoint.init(x: points[0].x, y: points[0].y), CGPoint.init(x: points[1].x, y: points[1].y))
        ls.info = info
        return ls
    }
    
    func equals(_ ls: LineSegment) -> Bool {
        return (ls.points[0].x == points[0].x && ls.points[0].y == points[0].y &&
            ls.points[1].x == points[1].x && ls.points[1].y == points[1].y) ||
            (ls.points[1].x == points[0].x && ls.points[1].y == points[0].y &&
                ls.points[0].x == points[1].x && ls.points[0].y == points[1].y)
    }
    
    func distanceTo(point: CGPoint) -> Double {
        let cenx = (points[0].x+points[1].x)/2.0
        let ceny = (points[0].y+points[1].y)/2.0
        return hypot(Double(cenx)-Double(point.x), Double(ceny)-Double(point.y))
    }
    
    func shrink(_ by: CGFloat) -> LineSegment {
        var pt: LineSegment!
        
        let p0 = points[0]
        let p1 = points[1]
        if(vertical) {
            if(points[0].y < points[1].y) {
                pt = LineSegment.init(CGPoint.init(x: p0.x, y: p0.y + by), CGPoint.init(x: p1.x, y: p1.y - by))
            } else {
                pt = LineSegment.init(CGPoint.init(x: p0.x, y: p0.y - by), CGPoint.init(x: p1.x, y: p1.y + by))
            }
        } else {
            if(points[0].x < points[1].x) {
                pt = LineSegment.init(CGPoint.init(x: p0.x + by, y: p0.y), CGPoint.init(x: p1.x - by, y: p1.y))
            } else {
                pt = LineSegment.init(CGPoint.init(x: p0.x - by, y: p0.y), CGPoint.init(x: p1.x + by, y: p1.y))
            }
        }
        
        return pt
    }
    
    func expand(_ by: CGFloat) -> LineSegment {
        return shrink(by * -1)
    }
}
