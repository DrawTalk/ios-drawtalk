//
//  AppleDelegate.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/25/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

import AddressBook
import AddressBookUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    let kUsername = "vkgogxez"
    let kPassword = "oX02eF7V0I9Y"
    
    MqttClientWrapper.defaultMQTT.setup(
      username: kUsername,
      password: kPassword,
      host: Constants.host,
      port: Constants.port
    )
    
    // Override point for customization after application launch.
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window!.rootViewController = MainTabBarController()
    self.window!.makeKeyAndVisible()
    
    // start up
    var queue = NSOperationQueue()
    var operation = RegistrationOperation()
    operation.controller = self.window!.rootViewController
    queue.addOperation(operation)
    
    //let picker = ABPeoplePickerNavigationController()
    //self.window!.rootViewController?.presentViewController(picker, animated: true, completion: nil)

    return true
  }
}