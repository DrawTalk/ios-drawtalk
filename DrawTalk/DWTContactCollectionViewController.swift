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
  
  class func controller() -> DWTArtboardViewController {
    let vc = DWTArtboardViewController(nibName:"DWTContactCollectionViewController", bundle: nil)
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMainCollectionView()
  }
  
  private func setupMainCollectionView() {
    mainCollectionDataSource = DWTContactCollectionDataSource(collectionView: mainCollectionView)
    mainCollectionView.dataSource = mainCollectionDataSource;
  }
}