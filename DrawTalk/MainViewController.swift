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
  }
  
  func setup() {
    //let conversation = ConversationViewController.controller(channel: "6504047096")
    //conversation.edgesForExtendedLayout = UIRectEdge.None;
    //let navigationController = UINavigationController(rootViewController: conversation)
    //addContentController(navigationController)
  }
  
  func addContentController(controller: UIViewController) {
    controller.willMoveToParentViewController(self)
    addChildViewController(controller)
    controller.view.frame = view.bounds
    view.addSubview(controller.view)
    controller.didMoveToParentViewController(self)
  }

}