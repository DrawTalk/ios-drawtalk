//
//  DWTContactsDataSource.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class ContactCollectionDataSource : NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
  
  private var contactCollectionView: UICollectionView!
  private var contacts: [Contact]!
  
  init(collectionView: UICollectionView) {
    super.init()
    contacts = []
    contactCollectionView = collectionView
    contactCollectionView.delegate = self
    contactCollectionView.backgroundColor = UIColor.whiteColor()
    registerCells()
  }
  
  func loadWithContacts(contacts: [Contact]?) {
    self.contacts = contacts;
    contactCollectionView.reloadData()
  }
  
  func registerCells() {
    contactCollectionView.registerNib(ContactCollectionViewCell.cellNib, forCellWithReuseIdentifier:ContactCollectionViewCell.reuseIdentifier)
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return contacts.count
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSizeMake(contactCollectionView.frame.size.width, 100)
  }
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      var cell = contactCollectionView.dequeueReusableCellWithReuseIdentifier(ContactCollectionViewCell.reuseIdentifier, forIndexPath:indexPath) as ContactCollectionViewCell
      
      var contact = contacts[indexPath.row] as Contact
      cell.bindObject(contact)
      
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