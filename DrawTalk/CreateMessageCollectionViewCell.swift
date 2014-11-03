//
//  CreateMessageCollectionViewCell.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/2/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class CreateMessageCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var buttonImageView: UIImageView!
  
  private var originalDrawing: Drawing!
  private var scaledDrawing: Drawing!
  
  var tapHandler: ((Drawing) -> Void)?
  
  class var reuseIdentifier: String {
    return "CreateMessageCollectionViewCell"
  }
  
  class var cellNib: UINib {
    return UINib(nibName: "CreateMessageCollectionViewCell", bundle: nil)
  }
  
  class var cellSize: CGSize {
    return CGSizeMake(100, 150)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
  }
  
  private func setupUI() {
    layoutMargins = UIEdgeInsetsZero
    buttonImageView.backgroundColor = UIColor.redColor()
    buttonImageView.round(90)
  }
}
