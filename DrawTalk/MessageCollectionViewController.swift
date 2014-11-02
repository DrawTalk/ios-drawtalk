//
//  MessageCollectionViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/30/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class MessageCollectionViewController : UIViewController, UICollectionViewDelegate {
  
  @IBOutlet weak var messageCollectionView: UICollectionView!
  
  private(set) var messageCollectionDataSource: MessageCollectionDataSource!
  
  class func controller() -> MessageCollectionViewController {
    let vc = MessageCollectionViewController(nibName:"MessageCollectionViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMessageCollectionView()
  }
  
  private func setupMessageCollectionView() {
    messageCollectionDataSource = MessageCollectionDataSource(collectionView: messageCollectionView)
    messageCollectionView.dataSource = messageCollectionDataSource;
  }
}