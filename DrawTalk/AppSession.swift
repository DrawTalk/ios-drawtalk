//
//  AppSession.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/9/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation

private let kUser = "user"

class AppSession {
  
  private var userDefaults: NSUserDefaults!
  private var _user: User?
  
  var currentUser: User? {
    get {
      if _user == nil {
        let user = userDefaults.dictionaryForKey(kUser)
        if let user = user {
          _user = User.fromJson(user)
        }
      }
      return _user
    }
    set {
      _user = newValue
    }
  }
  
  class var mainSession: AppSession {
    struct Static {
      static let instance = AppSession()
    }
    return Static.instance
  }
  
  init() {
    userDefaults =  NSUserDefaults.standardUserDefaults()
  }
  
  func saveUser(user: User) {
    weak var weakSelf:AppSession? = self
    dispatch_sync(dispatch_get_main_queue(), {
      weakSelf?.saveUser(user, state: UserState.Unverified)
      return
    })
  }
  
  func logUserIn(user: User) {
    weak var weakSelf:AppSession? = self
    dispatch_sync(dispatch_get_main_queue(), {
      weakSelf?.saveUser(user, state: UserState.Verified)
      return
    })
  }
  
  func logUserOut(user: User) {
    weak var weakSelf:AppSession? = self
    dispatch_sync(dispatch_get_main_queue(), {
      weakSelf?.userDefaults.removeObjectForKey(kUser)
      weakSelf?.currentUser = nil
    })
  }
  
  private func saveUser(user: User, state: UserState) {
    user.state = state
    currentUser = user
    userDefaults.setObject(user.toJson(), forKey: kUser)
    userDefaults.synchronize()
  }
}

private let kPhoneNumber = "phoneNumber"
private let kUserKey = "userKey"
private let kPrivateToken = "privateToken"
private let kState = "state"

enum UserState: Int {
  case Unverified
  case Verified
}

class User {
  
  private(set) var state: UserState = UserState.Unverified
  var phoneNumber: String?
  var userKey: String?
  var privateToken: String?
  
  required init() {}
  
  private func toJson() -> [NSObject : AnyObject] {
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
  
  private class func fromJson(json: [NSObject : AnyObject]) -> Self {
    var user = self()
    let p = json as NSDictionary
    user.phoneNumber = json[kPhoneNumber] as? String
    user.userKey = json[kUserKey] as? String
    user.privateToken = json[kPrivateToken] as? String
    user.state = UserState(rawValue: json[kState] as Int)!
    return user
  }
}