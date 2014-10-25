//
//  DWTMainTabBarController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/25/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit


class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
  
  private lazy var tabBarItemFont:UIFont = {
    return UIFont(name: "HelveticaNeue-Medium", size: 14)
    }()
  private let tabBarItemTitleOffset = UIOffsetMake(0, -10.0)
  private let tabBarItemTitleColor = UIColor.whiteColor()
  
  private var tabs: [TabContent]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    tabs = [
      ContactsTabContent(),
      ChatTabContent()
    ]
    
    setupContent()
  }
  
  func setupContent() {
    var controllers: [AnyObject] = []
    for tab: TabContent in tabs {
      var ctrl = tab.controller()
      let name = tab.tabName
      var root: UIViewController? = ctrl.viewControllers.first as? UIViewController
      root?.edgesForExtendedLayout = .None
      
      ctrl.tabBarItem.title = name
      ctrl.tabBarItem.setTitlePositionAdjustment(tabBarItemTitleOffset)
      ctrl.tabBarItem.setTitleTextAttributes(
        [
          NSForegroundColorAttributeName: UIColor.whiteColor(),
          NSFontAttributeName: tabBarItemFont
        ],
        forState: UIControlState.Normal)
      
      controllers.append(ctrl)
    }
    viewControllers = controllers;
  }
}

// Tab contents

protocol TabContent {
  var tabName: NSString { get }
  func controller() -> UINavigationController
}

private class ContactsTabContent: TabContent {
  var tabName: NSString {
    return "Contacts"
  }
  func controller() -> UINavigationController {
    let cv = DWTContactCollectionViewController.controller()
    let nav = UINavigationController(rootViewController: cv)
    return nav
  }
}

private class ChatTabContent: TabContent {
  var tabName: NSString {
    return "Chats"
  }
  func controller() -> UINavigationController {
    let kUsername = "vkgogxez"
    let kPassword = "oX02eF7V0I9Y"
    
    DWTMqttClientWrapper.defaultMQTT.setup(
      username: kUsername,
      password: kPassword,
      host: Constants.host,
      port: Constants.port
    )
    
    let artboard = DWTArtboardViewController.controller()
    let nav = UINavigationController(rootViewController: artboard)
    return nav
  }
}