//
//  DWTMainTabBarController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/25/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit


private protocol MainTabBarControllerProtocol {
  func openTab(type: TabType)
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, MainTabBarControllerProtocol {
  
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
    tabs.sort { $0.tabType.rawValue < $1.tabType.rawValue }
    
    setupContent()

    tabBar.translucent = false
    tabBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
  }
  
  func setupContent() {
    var controllers: [AnyObject] = []
    for tab: TabContent in tabs {
      var ctrl = tab.controller(self)
      var root: UIViewController? = ctrl.viewControllers.first as? UIViewController
      root?.edgesForExtendedLayout = .None
      ctrl.tabBarItem = tab.tabBarItem()
      controllers.append(ctrl)
    }
    viewControllers = controllers;
  }
  
  private func openTab(type: TabType) {
    selectedIndex = type.rawValue
  }
}

// Tab contents

private enum TabType: Int {
  case Contacts = 0
  case Chats = 1
}

private protocol TabContent {
  var tabType: TabType { get }
  func controller(parent: MainTabBarController) -> UINavigationController
  func tabBarItem() -> UITabBarItem
}

private class ContactsTabContent: TabContent, ContactsViewControllerDelegate {
  var tabType: TabType {
    return .Contacts
  }
  
  private(set) var parent: MainTabBarControllerProtocol?
  
  func controller(parent: MainTabBarController) -> UINavigationController {
    self.parent = parent
    let cv = ContactsViewController.controller()
    cv.contactsViewControllerDelegate = self
    
    let nav = UINavigationController(rootViewController: cv)
    nav.navigationBar.translucent = false
    nav.navigationBar.barTintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    return nav
  }
  
  func tabBarItem() -> UITabBarItem {
    return UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 1)
  }
  
  func contactsViewControllerDidDismissChat() {
    parent?.openTab(.Chats)
  }
}

private class ChatTabContent: TabContent {
  var tabType: TabType {
    return .Chats
  }
  
  func controller(parent: MainTabBarController) -> UINavigationController {
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