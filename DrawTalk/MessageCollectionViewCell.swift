//
//  MessageCollectionViewCell.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/30/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var personImageView: UIImageView!
  
  class var reuseIdentifier: String {
  return "MessageCollectionViewCell"
  }
  
  class var cellNib: UINib {
  return UINib(nibName: "MessageCollectionViewCell", bundle: nil)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func prepareForReuse() {
  }
  
  private func setupUI() {
    self.layoutMargins = UIEdgeInsetsZero
    let image = UIImage(named: "roman")
    personImageView.image = image.roundedImage()
  }
}

extension UIImage {
  func roundedImage() -> UIImage  {
    let imageSize = self.size;
    let imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0);
    // Create the clipping path and add it
    var path = UIBezierPath(ovalInRect: imageRect)
    path.addClip()
    
    drawInRect(imageRect)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage
  }
}