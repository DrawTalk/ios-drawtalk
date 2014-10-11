//
//  UIColor+Hex.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import UIKit

extension UIColor {
  
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

  public func hex() -> String? {
    let components = CGColorGetComponents(self.CGColor);
    let red = components[0]
    let green = components[1]
    let blue = components[2]
    let alpha = components[3];
    var hexString = String(format: "#%02X%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255), Int(alpha * 255))
    return hexString;
  }
}

