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