//
//  MessageCollectionDataSource.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/30/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

private let kNumberOfSections = 1

protocol MessageCollectionDataSourceDelegate {
  func didSelectMessage(drawing: Drawing)
}

class MessageCollectionDataSource : NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
  
  private var messageCollectionView: UICollectionView!
  private var messages: [Drawing?]!
  
  var messageCollectionDelegate: MessageCollectionDataSourceDelegate?
  
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
  
  func loadWithMessages(messages: [Drawing]?) {
    self.messages = messages
    messageCollectionView.reloadData()
  }
  
  func registerCells() {
    messageCollectionView.registerNib(MessageCollectionViewCell.cellNib, forCellWithReuseIdentifier:MessageCollectionViewCell.reuseIdentifier)
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return kNumberOfSections
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return MessageCollectionViewCell.cellSize
  }
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      var cell = messageCollectionView.dequeueReusableCellWithReuseIdentifier(MessageCollectionViewCell.reuseIdentifier, forIndexPath:indexPath) as MessageCollectionViewCell
      
      var drawing = messages[indexPath.row] as Drawing!
      cell.bindObject(drawing)
      cell.tapHandler = { (drawing: Drawing) in
        self.messageCollectionDelegate?.didSelectMessage(drawing)
        return
      }
      
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
  
  func addDrawing(drawing: Drawing?) {
    let lastIndexPath = NSIndexPath(forRow: messages.count, inSection: 0)
    messages.append(drawing)
    messageCollectionView.insertItemsAtIndexPaths([lastIndexPath])
    messageCollectionView.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
  }
}