//
//  RootViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/31/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
    view.backgroundColor = UIColor.whiteColor()
  }
  
  func setup() {
    var queue = NSOperationQueue()
    var register = RegistrationOperation()
    register.controller = self
    register.completionBlock = {
      dispatch_sync(dispatch_get_main_queue(), {
        println("register")
        self.addContentController(MainTabBarController())
        self.setupMQTT()
      })
    }
    queue.addOperation(register)
  }
  
  private func setupMQTT() {
    let kUsername = "vkgogxez"
    let kPassword = "oX02eF7V0I9Y"
    
    MqttClientWrapper.defaultMQTT.setup(
      username: kUsername,
      password: kPassword,
      host: Constants.host,
      port: Constants.port
    )
  }
  
  func addContentController(controller: UIViewController) {
    controller.willMoveToParentViewController(self)
    addChildViewController(controller)
    controller.view.frame = view.bounds
    view.addSubview(controller.view)
    controller.didMoveToParentViewController(self)
  }

}