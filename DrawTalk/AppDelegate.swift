//
//  AppleDelegate.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/25/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    // Override point for customization after application launch.
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    

    self.window!.rootViewController = MainTabBarController()
    self.window!.makeKeyAndVisible()
    
    return true
  }
}