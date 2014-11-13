//
//  User.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/12/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

private let kPhoneNumber = "phoneNumber"
private let kUserKey = "userKey"
private let kPrivateToken = "privateToken"
private let kState = "state"

enum UserState: Int {
  case Unverified
  case Verified
}

class User {
  
  var state: UserState = UserState.Unverified
  var phoneNumber: String?
  var userKey: String?
  var privateToken: String?
  
  required init() {}
}

extension User {
  func toJson() -> [NSObject : AnyObject] {
    var dict = [NSObject : AnyObject]()
    if let phoneNumber = phoneNumber {
      dict[kPhoneNumber] = phoneNumber
    }
    if let userKey = userKey {
      dict[kUserKey] = userKey
    }
    if let privateToken = privateToken {
      dict[kPrivateToken] = privateToken
    }
    
    dict[kState] = state.rawValue
    
    return dict
  }
  
  class func fromJson(json: [NSObject : AnyObject]) -> Self {
    var user = self()
    let p = json as NSDictionary
    user.phoneNumber = json[kPhoneNumber] as? String
    user.userKey = json[kUserKey] as? String
    user.privateToken = json[kPrivateToken] as? String
    user.state = UserState(rawValue: json[kState] as Int)!
    return user
  }
}
