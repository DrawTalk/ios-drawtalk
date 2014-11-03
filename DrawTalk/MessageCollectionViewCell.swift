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

  //@IBOutlet weak var canvasView: CanvasView!
  //@IBOutlet weak var pressableControl: PressableControl!
  
  @IBOutlet weak var thumbnail: ThumbnailView!
  
  private var originalDrawing: Drawing!
  private var scaledDrawing: Drawing!
  
  var tapHandler: ((Drawing) -> Void)?
  
  class var reuseIdentifier: String {
    return "MessageCollectionViewCell"
  }
  
  class var cellNib: UINib {
    return UINib(nibName: "MessageCollectionViewCell", bundle: nil)
  }
  
  class var cellSize: CGSize {
    return CGSizeMake(100, 150)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    thumbnail.thumbnailCanvasView.viewOnly = true
    thumbnail.thumbnailCanvasView.userInteractionEnabled = false
    //canvasView.viewOnly = true
    setupUI()
    //userInteractionEnabled = true
    //canvasView.userInteractionEnabled = false
  }
  
  override func prepareForReuse() {
  }
  
  private func setupUI() {
    layoutMargins = UIEdgeInsetsZero
  }
  
  func bindObject(drawing: Drawing) {
    // TODO: cache the normalized view, so it's not calculated every time the cell comes
    // into view
    originalDrawing = drawing
    scaledDrawing = drawing.normalizedToSize(thumbnail.thumbnailCanvasView.frame.size)
    thumbnail.thumbnailCanvasView.replay(scaledDrawing, animated: false)
  }
  
  @IBAction func pressableControlPressed(sender : AnyObject) {
    tapHandler?(originalDrawing)
  }
}

