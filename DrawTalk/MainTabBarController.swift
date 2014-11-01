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
    return UIFont(name: "HelveticaNeue-Medium", size: 14)!
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
    /*
    let x = DWTLocalizedStringWithDefaultValue(
      "records.found",
      tableName: "Localizable",
      bundle: NSBundle.mainBundle(),
      value: "%d file(s) remaining",
      comment: "Records found")
      
    let str = NSString.localizedStringWithFormat(x, 10)
    println(str)
    */
    return DWTLocalizedStringWithDefaultValue(
      "tab.contacts.title",
      tableName: "Localizable",
      bundle: NSBundle.mainBundle(),
      value: "Contacts",
      comment: "Name for contacts' tab")
  }
  func controller() -> UINavigationController {
    let cv = ContactCollectionViewController.controller()
    let nav = UINavigationController(rootViewController: cv)
    return nav
  }
}

private class ChatTabContent: TabContent {
  var tabName: NSString {
    return DWTLocalizedStringWithDefaultValue(
      "tab.chat.title",
      tableName: "Localizable",
      bundle: NSBundle.mainBundle(),
      value: "Chats",
      comment: "Name for chats' tab")
  }
  func controller() -> UINavigationController {
    let artboard = ArtboardViewController.controller()
    let nav = UINavigationController(rootViewController: artboard)
    return nav
  }
}