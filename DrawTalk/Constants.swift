//
//  DWTConstants.swift
//  DrawTalk
//
//  Created by Kirolblos Risk on 10/18/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class Constants {}

extension Constants {
  // tcp:// or mqtt://
  class var host: String {
    return "m10.cloudmqtt.com"
  }
  class var port: UInt16 {
    return 16056
  }
  class var topicPrefix: String {
    return ""
  }
}

extension Constants {
  class var deviceId: String {
    return UIDevice.currentDevice().identifierForVendor.UUIDString
  }
}

extension Constants {
  class var apiUrl: String {
    return "http://drawtalk.herokuapp.com/drawtalk/api"
  }
}