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
    self.window!.rootViewController = MainViewController()
    self.window!.makeKeyAndVisible()

    var q = NSOperationQueue()
    
    // Acquire verification code
    var op1 = AcquireVerificationCodeOperation(serverRequest: AcquireVerificationCodeRequest(number: "6504047096"))
    op1.completionBlock = {
    }
    q.addOperation(op1)

    // Send verification code
    var op2 = SendVerificationCodeOperation(serverRequest: SendVerificationCodeRequest(number: "6504047096", code: "death"))
    op2.completionBlock = {
    }
    op2.addDependency(op1)
    q.addOperation(op2)

    return true
  }
}