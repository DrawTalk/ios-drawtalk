//
//  DWTPath.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

struct Pair {
  var pointA: CGPoint
  var pointB: CGPoint
}

class Path {
  var coords: [CGPoint] = []
  var color: UIColor = UIColor.blackColor()
  var brush: CGFloat = 1.0
  var duration: NSTimeInterval = 0.01
  
  required init() {
  }
  
  convenience init (coords: [CGPoint], color: UIColor, brush: CGFloat, duration: NSTimeInterval) {
    self.init()
    self.coords = coords
    self.color = color
    self.brush = brush
    self.duration = duration
  }
  
  func pairs() -> [DrawTalk.Pair] {
    // If there's only one coord, then the pair is just the same point
    if coords.count == 1 {
      let point: CGPoint = coords[0]
      return [DrawTalk.Pair(pointA: point, pointB: point)]
    }
    // Otherwise, assemble the pairs
    var prevPoint: CGPoint?
    var pairs: [DrawTalk.Pair] = []
    for point: CGPoint in coords {
      if prevPoint != nil {
        pairs.append(DrawTalk.Pair(pointA: prevPoint!, pointB: point))
      }
      prevPoint = point
    }
    
    return pairs
  }
}