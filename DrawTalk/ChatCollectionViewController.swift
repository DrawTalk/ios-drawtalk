//
//  DWTContactsViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class ChatCollectionViewController : UIViewController, UICollectionViewDelegate {
  
  @IBOutlet weak var mainCollectionView: UICollectionView!
  
  private(set) var mainCollectionDataSource: ChatCollectionDataSource!
  
  class func controller() -> ChatCollectionViewController {
    let vc = ChatCollectionViewController(nibName:"ChatCollectionViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    setupMainCollectionView()
  }
  
  private func loadChats() {
    let cdChats = CINPersistence.defaultPersistence?.findAllForClass(CDChat.self,
      withPredicate: nil,
      sortedBy: nil,
      ascending: false,
      groupBy: nil) as [CDChat]
  }
  
  private func setupNavigationBar() {
    let navigationItemTitle = DWTLocalizedStringWithDefaultValue(
      "screen.chats.navigation-bar.title",
      tableName: "Localizable",
      bundle: NSBundle.mainBundle(),
      value: "Chats",
      comment: "Title for chats' screen")
    
    navigationItem.title = navigationItemTitle
  }
  
  private func setupMainCollectionView() {
    mainCollectionDataSource = ChatCollectionDataSource(collectionView: mainCollectionView)
    mainCollectionView.dataSource = mainCollectionDataSource;
  }
}