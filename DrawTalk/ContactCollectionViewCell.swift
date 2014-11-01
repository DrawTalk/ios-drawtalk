//
//  DWTContactCollectionViewCell.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  class var reuseIdentifier: String {
    return "DWTContactCollectionViewCell"
  }
  
  class var cellNib: UINib {
    return UINib(nibName: "DWTContactCollectionViewCell", bundle: nil)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
    nameLabel.text = ""
  }
  
  private func setupUI() {
    self.layoutMargins = UIEdgeInsetsZero
  }
  
  func bindObject(object: Contact) {
    self.nameLabel.text = object.firstName
  }
  
}
