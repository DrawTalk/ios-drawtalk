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

  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var pressableControl: PressableControl!
  
  private var drawing: Drawing!
  
  var tapHandler: ((Drawing) -> Void)?
  
  class var reuseIdentifier: String {
    return "MessageCollectionViewCell"
  }
  
  class var cellNib: UINib {
    return UINib(nibName: "MessageCollectionViewCell", bundle: nil)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    canvasView.viewOnly = true
    setupUI()
    userInteractionEnabled = true
    canvasView.userInteractionEnabled = false
  }
  
  override func prepareForReuse() {
  }
  
  private func setupUI() {
    layoutMargins = UIEdgeInsetsZero
    //let image = UIImage(named: "roman")
    //personImageView.image = image?.roundedImage()
  }
  
  func bindObject(drawing: Drawing) {
    // TODO: cache the normalized view, so it's not calculated every time the cell comes
    // into view
    self.drawing = drawing.normalizedToSize(canvasView.frame.size)
    canvasView.replay(self.drawing, animated: false)
  }
  
  @IBAction func pressableControlPressed(sender : AnyObject) {
    tapHandler?(self.drawing)
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