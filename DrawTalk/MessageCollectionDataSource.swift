//
//  MessageCollectionDataSource.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/30/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class MessageCollectionDataSource : NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
  
  private var messageCollectionView: UICollectionView!
  private var messages: [Int]!
  
  init(collectionView: UICollectionView) {
    super.init()
    messages = []
    messageCollectionView = collectionView
    
    var flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    messageCollectionView.collectionViewLayout = flowLayout
    messageCollectionView.delegate = self
    messageCollectionView.backgroundColor = UIColor.whiteColor()
    registerCells()
  }
  
  func loadWithMessages(messages: [Int]?) {
    self.messages = messages;
    messageCollectionView.reloadData()
  }
  
  func registerCells() {
    messageCollectionView.registerNib(MessageCollectionViewCell.cellNib, forCellWithReuseIdentifier:MessageCollectionViewCell.reuseIdentifier)
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSizeMake(80, 80)
  }
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      var cell = messageCollectionView.dequeueReusableCellWithReuseIdentifier(MessageCollectionViewCell.reuseIdentifier, forIndexPath:indexPath) as MessageCollectionViewCell
      
      //var message = messages[indexPath.row] as Contact
      //cell.bindObject(contact)
      
      return cell
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {
      return UIEdgeInsetsMake(0, 0, 1, 0)
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
      return 0
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
      return 0
  }
}