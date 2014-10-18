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

protocol SerializableProtocol {
  class func fromJSON(json: AnyObject) -> Self
  class func toJSON(item: Self) -> Dictionary<String, AnyObject>
}

protocol MessageProtocol {
}

public class PathCollection: MessageProtocol, SerializableProtocol {
  var paths: [DrawTalk.Path]?
  var grid: CGSize = CGSizeZero
  
  required public init() {
    // Does nothing, but we need it for the class methods below, since they construct an object of class type 'Self'
    // with a metatype value, which can only work if there's a 'required initializer'
    // What a majectic pain. Some lovely initialization inference would be much appreciated.
  }
  
  public init (paths: [Path], grid: CGSize) {
    self.paths = paths
    self.grid = grid
  }
  
  class func fromJSON(json: AnyObject) -> Self {
    var permission = self()

    var error: NSError?
    let message = (json as String).dataUsingEncoding(NSUTF8StringEncoding)!
    let result: AnyObject? = NSJSONSerialization.JSONObjectWithData(message, options: nil, error: &error)
    
    if let data = result as? Dictionary<String, AnyObject> {
      if let pathsArr = data["paths"]! as? [DrawTalk.PathJSON] {
        permission.paths = pathsArr.map({ (dict: DrawTalk.PathJSON) -> DrawTalk.Path in
          return DrawTalk.Path.fromJSON(dict)
        })
      }
      if let grid = data["grid"]! as? [CGFloat] {
        permission.grid = CGSizeMake(grid[0], grid[1])
      }
    }
    
    return permission
  }
  
  class func toJSON(item: PathCollection) -> Dictionary<String, AnyObject> {
    let data: [DrawTalk.PathJSON] = item.paths!.map({ (path: DrawTalk.Path) -> DrawTalk.PathJSON in
      return DrawTalk.Path.toJSON(path)
    })
    
    let json: Dictionary<String, AnyObject> = [
      "paths" : data,
      "grid": [item.grid.width, item.grid.height]
    ]
    return json
  }
}

public class Path: SerializableProtocol {
  var coords: [CGPoint] = []
  var color: UIColor = UIColor.blackColor()
  var brush: CGFloat = 1.0
  var duration: NSTimeInterval = 0.01
  
  required public init() {
  }

  convenience public init (coords: [CGPoint], color: UIColor, brush: CGFloat, duration: NSTimeInterval) {
    self.init()
    self.coords = coords
    self.color = color
    self.brush = brush
    self.duration = duration
  }
  
  class func fromJSON(json: AnyObject) -> Self {
    let rawCoords = json["coords"]! as [[CGFloat]]
    let coords: [CGPoint] = rawCoords.map({ (point: [CGFloat]) -> CGPoint in
      return CGPointMake(point[0], point[1])
    })
    
    let hexString = json["color"]! as String
    let color = UIColor(hex: hexString)
    
    let brush = json["brush"]! as CGFloat
    let duration = json["duration"]! as NSTimeInterval
    
    // This is so stupid
    var p = self()
    p.coords = coords
    p.brush = brush
    p.duration = duration
    p.color = color

    return p
  }
  
  class func toJSON(item: Path) -> Dictionary<String, AnyObject> {
    var arr: [[CGFloat]] = item.coords.map({ (point: CGPoint) -> [CGFloat] in
      return [point.x, point.y]
    })
    var hex = item.color.hex()
    var json: DrawTalk.PathJSON = [
      "coords": arr,
      "color": hex!,
      "brush": item.brush,
      "duration": item.duration,
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
