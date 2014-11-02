//
//  UIColor+Hex.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import UIKit

public struct RGBA {
  var red: CGFloat
  var green: CGFloat
  var blue: CGFloat
  var alpha: CGFloat = 1.0
}

extension UIColor {
  
  convenience init(hex: String) {
    var red:CGFloat   = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat  = 0.0
    var alpha:CGFloat = 1.0
    
    let scanner = NSScanner(string: hex)
    var hexValue: UInt32 = 0
    if scanner.scanHexInt(&hexValue) {
      if countElements(hex) == 8 {
        red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
        green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
        blue  = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
        alpha = CGFloat((hexValue & 0x000000FF)) / 255.0
      } else if countElements(hex) == 6 {
        red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        blue  = CGFloat((hexValue & 0x0000FF)) / 255.0
      }
    }
    
    self.init(red:red, green:green, blue:blue, alpha:alpha)
  }
  
  /*
  convenience init(rgba: String) {
    var red:   CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue:  CGFloat = 0.0
    var alpha: CGFloat = 1.0

    if rgba.hasPrefix("#") {
      let index   = advance(rgba.startIndex, 1)
      let hex     = rgba.substringFromIndex(index)
      let scanner = NSScanner.scannerWithString(hex)
      var hexValue: CUnsignedLongLong = 0
      if scanner.scanHexLongLong(&hexValue) {
        if countElements(hex) == 6 {
          red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
          green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
          blue  = CGFloat(hexValue & 0x0000FF) / 255.0
        } else if countElements(hex) == 8 {
          red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
          green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
          blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
          alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
        } else {
          print("invalid rgb string, length should be 7 or 9")
        }
      } else {
        println("scan hex error")
      }
    } else {
      print("invalid rgb string, missing '#' as prefix")
    }
    self.init(red:red, green:green, blue:blue, alpha:alpha)
  }
  */

  // returns RGBA format for color string
  public func hex() -> String? {
    let rgba = rgbaValues()

    var hexString = String(format: "#%0.2X%0.2X%0.2X%0.2X",
      Int(rgba.red * 255),
      Int(rgba.green * 255),
      Int(rgba.blue * 255),
      Int(rgba.alpha * 255))
    
    return hexString;
  }
  
  public func rgbaValues() -> RGBA {
    let components = CGColorGetComponents(self.CGColor);
    let red = min(components[0], 1)
    let green = min(components[1], 1)
    let blue = min(components[2], 1)
    let alpha = min(CGColorGetAlpha(self.CGColor), 1)
    
    return RGBA(red: red, green: green, blue: blue, alpha: alpha)
  }
}

