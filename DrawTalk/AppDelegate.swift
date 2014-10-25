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
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions:     NSDictionary?) -> Bool {
    // Override point for customization after application launch.
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    let kUsername = "vkgogxez"
    let kPassword = "oX02eF7V0I9Y"
    
    DWTMqttClientWrapper.defaultMQTT.setup(username: kUsername, password: kPassword, host: Constants.host(), port: Constants.port())
    
    var artboard = DWTArtboardViewController.controller()
    var contacts = DWTContactCollectionViewController.controller()
    
    self.window!.rootViewController = artboard
    self.window!.makeKeyAndVisible()
    
    return true
  }
}