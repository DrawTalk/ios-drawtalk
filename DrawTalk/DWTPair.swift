//
//  DWTPair.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/17/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

typealias PathJSON = Dictionary<String, AnyObject>

public struct Pair {
  var pointA: CGPoint
  var pointB: CGPoint
}

public struct Path {
  var coords: [CGPoint]
  var color: UIColor = UIColor.blackColor()
  var brush: CGFloat = 1.0
  var duration: NSTimeInterval = 0.01
  
  static func fromJSON(dict: Dictionary<String, AnyObject>) -> Path {
    let rawCoords = dict["coords"]! as [[CGFloat]]
    let coords: [CGPoint] = rawCoords.map({ (point: [CGFloat]) -> CGPoint in
      return CGPointMake(point[0], point[1])
    })
    
    let hexString = dict["color"]! as String
    let color = UIColor(rgba: hexString)
    
    let brush = dict["brush"]! as CGFloat
    let duration = dict["duration"]! as NSTimeInterval
    
    return Path(coords: coords, color: color, brush: brush, duration: duration)
  }
  
  func toJSON() -> DrawTalk.PathJSON {
    var arr: [[CGFloat]] = coords.map({ (point: CGPoint) -> [CGFloat] in
      return [point.x, point.y]
    })
    var hex = color.hex()
    var json : DrawTalk.PathJSON = [
      "coords": arr,
      "color": hex!,
      "brush": brush,
      "duration": duration,
    ]
    return json
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
