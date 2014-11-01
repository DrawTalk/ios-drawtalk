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
  
  private var messageCollectionDataSource: MessageCollectionDataSource!
  
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
    messageCollectionDataSource.loadWithMessages([1,2,3,4,5,6,7,8,9,10])
  }
}