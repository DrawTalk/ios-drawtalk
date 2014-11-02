//
//  DWTContactsViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class ContactCollectionViewController : UIViewController, UICollectionViewDelegate {
  
  @IBOutlet weak var mainCollectionView: UICollectionView!
  
  private(set) var mainCollectionDataSource: ContactCollectionDataSource!
  
  class func controller() -> ContactCollectionViewController {
    let vc = ContactCollectionViewController(nibName:"ContactCollectionViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMainCollectionView()
    retrieveContactsFromAddressBook()
  }
  
  private func setupMainCollectionView() {
    mainCollectionDataSource = ContactCollectionDataSource(collectionView: mainCollectionView)
    mainCollectionView.dataSource = mainCollectionDataSource;
  }
  
  private func retrieveContactsFromAddressBook() {
    AddressBookImport.defaultAddressBookImport.contacts {
      (contacts: [Contact]?, error: NSError?) in
      dispatch_async(dispatch_get_main_queue(), {
        self.mainCollectionDataSource.loadWithContacts(contacts)
        println(contacts?)
      })
    }
  }
}