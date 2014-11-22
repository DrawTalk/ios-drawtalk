//
//  MessageCollectionViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/30/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

protocol MessageCollectionDelegate {
  func didSelectMessage(drawing: Drawing)
}

private let kNumberOfSections = 1

class MessageCollectionViewController : UIViewController {
  
  @IBOutlet weak var messageCollectionView: UICollectionView!
  
  var messageCollectionDelegate: MessageCollectionDelegate?
  
  private var messages: [Drawing?]!
  
  class func controller() -> MessageCollectionViewController {
    let vc = MessageCollectionViewController(nibName:"MessageCollectionViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMessageCollectionView()
  }
  
  private func setupMessageCollectionView() {
    messages = []
    messageCollectionView.backgroundColor = StyleGuide.defaultStyle.color50
    messageCollectionView.showsHorizontalScrollIndicator = false
    messageCollectionView.dataSource = self
    
    var flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    
    messageCollectionView.collectionViewLayout = flowLayout
    messageCollectionView.delegate = self
    messageCollectionView.backgroundColor = StyleGuide.defaultStyle.color50
    registerCells()
  }
  
  func loadWithMessages(messages: [Drawing]?) {
    self.messages = messages
    messageCollectionView.reloadData()
  }
  
  func registerCells() {
    messageCollectionView.registerNib(MessageCollectionViewCell.cellNib, forCellWithReuseIdentifier:MessageCollectionViewCell.reuseIdentifier)
  }
  
  func addDrawing(drawing: Drawing?) {
    let lastIndexPath = NSIndexPath(forRow: messages.count, inSection: 0)
    messages.append(drawing)
    
    messageCollectionView.performBatchUpdates({ () -> Void in
      self.messageCollectionView.insertItemsAtIndexPaths([lastIndexPath])
      }, completion: { (complete) -> Void in
        self.messageCollectionView.scrollToItemAtIndexPath(lastIndexPath,
          atScrollPosition: UICollectionViewScrollPosition.Right,
          animated: true)
    })
    
  }

}

extension MessageCollectionViewController : UICollectionViewDataSource {
  
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
      
      var cell: MessageCollectionViewCell = messageCollectionView.dequeueReusableCellWithReuseIdentifier(MessageCollectionViewCell.reuseIdentifier, forIndexPath:indexPath) as MessageCollectionViewCell
      
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
      return UIEdgeInsetsMake(0, 5, 0, 0)
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
      return 5
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
      return 0
  }
}

extension MessageCollectionViewController : UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    var drawing = messages[indexPath.row] as Drawing!
    var cell = collectionView.cellForItemAtIndexPath(indexPath) as MessageCollectionViewCell
    
    cell.thumbnail.play(drawing.duration)
    messageCollectionDelegate?.didSelectMessage(drawing)
  }
}