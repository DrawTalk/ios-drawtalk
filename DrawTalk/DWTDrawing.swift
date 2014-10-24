//
//  DWTDrawing.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

public class Drawing {
  var paths: [DrawTalk.Path] = []
  var grid: CGSize = CGSizeZero

  required public init() {
  }

  convenience public init (paths: [DrawTalk.Path], grid: CGSize) {
    self.init()
    self.paths = paths
    self.grid = grid
  }
}

extension Drawing {

  func normalizedToSize(size: CGSize) -> Drawing {
    if CGSizeEqualToSize(size, self.grid) {
      return self
    }

    var newDrawing = Drawing()
    var newGrid = CGSizeZero
    var offset = CGPointZero

    var factor: CGFloat = 1
    let currentRatio = size.width / size.height;
    let otherRatio = self.grid.width / self.grid.height;

    if otherRatio > currentRatio {
      factor = size.width / self.grid.width
      newGrid = CGSizeMake(size.width, size.width / otherRatio)
      offset = CGPointMake(0, (size.height - newGrid.height) / 2)
    } else {
      factor = size.height / self.grid.height
      newGrid = CGSizeMake(size.height * otherRatio, size.height)
      offset = CGPointMake((size.width - newGrid.width) / 2, 0)
    }

    newDrawing.paths = self.paths.map { (path: DrawTalk.Path) -> DrawTalk.Path in
      var newPath = Path()
      newPath.color = path.color
      newPath.brush = path.brush
      newPath.duration = path.duration
      newPath.coords = path.coords.map({ (point: CGPoint) -> CGPoint in
        return CGPointMake(point.x * factor + offset.x, point.y * factor + offset.y)
      })
      return newPath
    }

    return newDrawing
  }
}