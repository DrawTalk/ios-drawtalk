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
  
  private var tabs: [TabContent]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    
    self.navigationItem
    tabs = [
      ContactsTabContent(),
      ChatTabContent()
    ]
    
    setupContent()

    tabBar.translucent = false
    tabBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
  }
  
  func setupContent() {
    var controllers: [AnyObject] = []
    for tab: TabContent in tabs {
      var ctrl = tab.controller()
      var root: UIViewController? = ctrl.viewControllers.first as? UIViewController
      root?.edgesForExtendedLayout = .None
      ctrl.tabBarItem = tab.tabBarItem()
      controllers.append(ctrl)
    }
    viewControllers = controllers;
  }
}

// Tab contents

protocol TabContent {
  func controller() -> UINavigationController
  func tabBarItem() -> UITabBarItem
}

private class ContactsTabContent: TabContent {
  func controller() -> UINavigationController {
    let cv = ContactsViewController.controller()
    let nav = UINavigationController(rootViewController: cv)
    nav.navigationBar.translucent = false
    nav.navigationBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    return nav
  }
  func tabBarItem() -> UITabBarItem {
    return UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 1)
  }
}

private class ChatTabContent: TabContent {
  func controller() -> UINavigationController {
    let conversation = ChatCollectionViewController.controller()
    let nav = UINavigationController(rootViewController: conversation)
    nav.navigationBar.translucent = false
    nav.navigationBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    return nav
  }
  func tabBarItem() -> UITabBarItem {
    let tabName = DWTLocalizedStringWithDefaultValue(
      "tab.chat.title",
      tableName: "Localizable",
      bundle: NSBundle.mainBundle(),
      value: "Chats",
      comment: "Name for chats' tab")
    
    var item = UITabBarItem(title: tabName, image: nil, tag: 2)
    return item
  }
}