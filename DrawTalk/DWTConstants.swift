//
//  DWTConstants.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

@objc
class Constants {
  // tcp:// or mqtt://
  class func host() -> String {
    return "m10.cloudmqtt.com"
  }
  class func port() -> UInt16 {
    return 16056
  }
}