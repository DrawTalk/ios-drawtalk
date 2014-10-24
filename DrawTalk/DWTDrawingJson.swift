//
//  DWTDrawingJson.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

public class DrawingJson {
  var paths: [DrawTalk.PathJson] = []
  var grid: [CGFloat] = []
  
  required public init() {
  }
  
  convenience public init (json: JSON) {
    self.init()
    let paths = json["paths"].arrayValue
    let grid = json["grid"]
    
    self.paths = paths.map({ (json: JSON) -> DrawTalk.PathJson in
      return DrawTalk.PathJson(json: json)
    })
    self.grid = [CGFloat(grid[0].floatValue), CGFloat(grid[1].floatValue)]
  }
  
  convenience public init (drawing: DrawTalk.Drawing) {
    self.init()
    self.paths = drawing.paths.map({ (path: DrawTalk.Path) -> DrawTalk.PathJson in
      return DrawTalk.PathJson(path: path)
    })
    self.grid = [drawing.grid.width, drawing.grid.height]
  }
  
  public func toJson() -> AnyObject {
    var p: [AnyObject] = self.paths.map({ (pathJson: DrawTalk.PathJson) -> AnyObject in
      return pathJson.toJson()
    })
    
    var json = [
      "paths": p,
      "grid": self.grid
    ]
    return json
  }
  
  public func jsonString() -> NSString {
    var jsonError: NSError?
    let encodedJsonData: NSData? = NSJSONSerialization.dataWithJSONObject(toJson(), options: nil, error: &jsonError)
    let encodedJsonString: NSString = NSString(data: encodedJsonData!, encoding: NSUTF8StringEncoding)
    println(encodedJsonString)
    return encodedJsonString
  }
  
  public func toDrawing() -> Drawing {
    var drawing = Drawing()
    drawing.paths = self.paths.map({ (pathJson: DrawTalk.PathJson) -> DrawTalk.Path in
      return pathJson.toPath()
    })
    drawing.grid = CGSizeMake(self.grid[0], self.grid[1])
    
    return drawing
  }
}
