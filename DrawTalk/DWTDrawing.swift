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