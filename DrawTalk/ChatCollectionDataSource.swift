//
//  DWTContactsDataSource.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class ChatCollectionDataSource : NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
  
  private var chatCollectionView: UICollectionView!
  private var chats: [Contact]!
  
  init(collectionView: UICollectionView) {
    super.init()
    chats = []
    chatCollectionView = collectionView
    chatCollectionView.delegate = self
    chatCollectionView.backgroundColor = UIColor.whiteColor()
    registerCells()
  }
  
  func loadWithChats(chats: [Contact]?) {
    self.chats = chats;
    chatCollectionView.reloadData()
  }
  
  func registerCells() {
    chatCollectionView.registerNib(ChatCollectionViewCell.cellNib, forCellWithReuseIdentifier:ChatCollectionViewCell.reuseIdentifier)
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return chats.count
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSizeMake(chatCollectionView.frame.size.width, 100)
  }
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      var cell = chatCollectionView.dequeueReusableCellWithReuseIdentifier(ChatCollectionViewCell.reuseIdentifier, forIndexPath:indexPath) as ChatCollectionViewCell
      
      var contact = chats[indexPath.row] as Contact
      cell.bindObject(contact)
      
      return cell
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {
      return UIEdgeInsetsMake(0, 0, 0, 0)
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