//
//  StyleGuide.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/17/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

// Using: http://www.google.com/design/spec/style/color.html#color-color-palette

import Foundation

protocol Style {
  var color500: UIColor { get }
  var color50: UIColor { get }
  var color900: UIColor { get }
}

private class CyanStyle: Style {
  var color500: UIColor {
    return UIColor(hex: "00BCD4")
  }
  
  var color50: UIColor {
    return UIColor(hex: "E0F7FA")
  }
  
  var color900: UIColor {
    return UIColor(hex: "006064")
  }
}

class StyleGuide {
  
  class var defaultStyle: Style {
    struct Static {
      static let instance = CyanStyle()
    }
    return Static.instance
  }
}