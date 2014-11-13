//
//  DWTContactCollectionViewCell.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/23/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  class var reuseIdentifier: String {
    return "ChatCollectionViewCell"
  }
  
  class var cellNib: UINib {
    return UINib(nibName: "ChatCollectionViewCell", bundle: nil)
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
