//
//  DWTPathJson.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class PathJson {
  var coords: [[CGFloat]] = []
  var color: String?
  var brush: CGFloat = 1.0
  var duration: NSTimeInterval = 0.01

  
  required init() {
    color = UIColor.blackColor().hex()
  }
  
  convenience init(json: JSON) {
    self.init()
    let coords = json["coords"].arrayValue

    self.coords = coords.map({ (coord: JSON) -> [CGFloat] in
      return [CGFloat(coord[0].floatValue), CGFloat(coord[1].floatValue)]
    })
    self.color = json["color"].stringValue
    self.brush = CGFloat(json["brush"].floatValue)
    self.duration = json["duration"].doubleValue
  }
  
  convenience init(path: Path) {
    self.init()
    
    self.coords = path.coords.map({ (point: CGPoint) -> [CGFloat] in
      return [point.x, point.y]
    })
    
    if let color = path.color.hex() {
      self.color = color
    }
    
    self.brush = path.brush
    self.duration = path.duration
  }
  
  func toJson() -> AnyObject {
    var json = [
      "coords": self.coords,
      "color": self.color!,
      "brush": self.brush,
      "duration": self.duration 
    ]
    return json
  }

}

extension PathJson {
  
  func toPath() -> Path {
    let path = Path()
    path.coords = self.coords.map({ (point: [CGFloat]) -> CGPoint in
      return CGPointMake(point[0], point[1])
    })
    path.brush = self.brush
    path.duration = self.duration
    path.color = UIColor(hex: self.color!)
    
    return path
  }
  
}