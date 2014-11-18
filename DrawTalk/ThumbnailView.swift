//
//  ThumbnailView.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/2/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

enum PlaybackState {
    case Stop, Play
    mutating func toggle() {
        switch self {
        case Stop:
            self = Play
        case Play:
            self = Stop
        }
    }
}

class ThumbnailView: UIView {

  private var progressImageView: UIImageView!
  private var backgroundImageView: UIImageView!
  private(set) var thumbnailCanvasView: CanvasView!
  
  private var state = PlaybackState.Stop
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  override init() {
    super.init()
    setupUI()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  
  private func setupUI() {
    progressImageView = UIImageView()
    backgroundImageView = UIImageView()
    thumbnailCanvasView = CanvasView()
    
    addSubview(progressImageView)
    progressImageView.addSubview(backgroundImageView)
    progressImageView.addSubview(thumbnailCanvasView)
    
    progressImageView.setTranslatesAutoresizingMaskIntoConstraints(true)
    progressImageView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
    progressImageView.frame = self.bounds
    progressImageView.backgroundColor = UIColor(red: 179.0/255.0, green: 212.0/255.0, blue: 225.0/255.0, alpha: 1)
    progressImageView.round(self.bounds.size.width)
    
    let backgroundScale = self.bounds.scaledTo(0.9)
    backgroundImageView.setTranslatesAutoresizingMaskIntoConstraints(true)
    backgroundImageView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
    backgroundImageView.frame = backgroundScale
    backgroundImageView.center = progressImageView.center
    backgroundImageView.backgroundColor = UIColor.whiteColor()
    backgroundImageView.round(backgroundScale.size.width)
    
    let thumbnailScale = self.bounds.scaledTo(0.8)
    thumbnailCanvasView.setTranslatesAutoresizingMaskIntoConstraints(true)
    thumbnailCanvasView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
    thumbnailCanvasView.frame = thumbnailScale
    thumbnailCanvasView.center = progressImageView.center
    thumbnailCanvasView.round(thumbnailScale.size.width)
  }
  
  private var progressIndicator: CAShapeLayer?
  
  func changeState() {
    state.toggle()
    
    switch state {
    case .Play:
      play(1)
    case .Stop:
      stop()
    }
  }
  
  func stop() {
    state = .Stop
    progressIndicator?.removeAllAnimations()
    progressIndicator?.removeFromSuperlayer()
    progressIndicator = nil
  }

  func play(duration: NSTimeInterval) {
    stop()
    
    state = .Play
    
    // What a majestic pain
    let radius: CGFloat = progressImageView.frame.size.width/2
    progressIndicator = CAShapeLayer()
    
    var circle = progressIndicator!
    
    var rect = CGRectMake(0, 0, 2.0 * radius, 2.0 * radius)
    circle.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).CGPath
    circle.position = CGPointMake(CGRectGetMidX(progressImageView.frame) - radius, CGRectGetMidY(progressImageView.frame) - radius);
    circle.fillColor = UIColor.clearColor().CGColor;
    circle.strokeColor =  UIColor(red: 0/255, green: 96/255, blue: 100/255, alpha: 1).CGColor;
    circle.lineWidth = 10;
    
    progressImageView.layer.addSublayer(circle)
    
    CATransaction.begin()
    
    CATransaction.setCompletionBlock { () -> Void in
      
      CATransaction.begin()
      
      CATransaction.setCompletionBlock { () -> Void in
        self.stop()
      }
      
      // Fade it out
      var opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath:"opacity")
      opacityAnimation.duration = 0.33
      opacityAnimation.fromValue = 1.0
      opacityAnimation.toValue = 0
      opacityAnimation.fillMode = kCAFillModeForwards;
      opacityAnimation.removedOnCompletion = false
      opacityAnimation.timingFunction = CAMediaTimingFunction(name: "linear")
      opacityAnimation.repeatCount = 0
      circle.addAnimation(opacityAnimation, forKey:"opacityAnimation")
      
      CATransaction.commit()
    }
    // Configure animation
    var drawAnimation: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
    drawAnimation.duration = duration
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = 0
    drawAnimation.toValue = 1.0
    drawAnimation.removedOnCompletion = true
    
    drawAnimation.timingFunction = CAMediaTimingFunction(name: "linear")
    circle.addAnimation(drawAnimation, forKey:"drawCircleAnimation")
    
    CATransaction.commit()
  }
}

private extension CGRect {
  func scaledTo(factor: CGFloat) -> CGRect {
    var frame = self
    frame.size.width *= factor
    frame.size.height *= factor
    return frame
  }
}