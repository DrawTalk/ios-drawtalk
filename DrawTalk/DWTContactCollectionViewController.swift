//
//  DWTContactsViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class DWTContactCollectionViewController : UIViewController, UICollectionViewDelegate {
  
  @IBOutlet weak var mainCollectionView: UICollectionView!
  
  private var mainCollectionDataSource: DWTContactCollectionDataSource!
  
  class func controller() -> DWTContactCollectionViewController {
    let vc = DWTContactCollectionViewController(nibName:"DWTContactCollectionViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMainCollectionView()
    retrieveContactsFromAddressBook()
  }
  
  private func setupMainCollectionView() {
    mainCollectionDataSource = DWTContactCollectionDataSource(collectionView: mainCollectionView)
    mainCollectionView.dataSource = mainCollectionDataSource;
  }
  
  private func retrieveContactsFromAddressBook() {
    DWTAddressBookImport.defaultAddressBookImport.contacts {
      (contacts: [Contact]?, error: NSError?) in
      dispatch_async(dispatch_get_main_queue(), {
        self.mainCollectionDataSource.loadWithContacts(contacts)
        println(contacts?)
      })
    }
  }
}