//
//  PressableControl.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/1/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

private let kPressedShrinkScale: CGFloat    = 0.94
private let kPressedShrinkDuration: NSTimeInterval = 0.45
private let kPressedShrinkDamping: CGFloat  = 0.45

class PressableControl: UIButton {
  
  // MARK: - Pressability
  
  private func scaleIn(touch: UITouch) {
    transform = CGAffineTransformIdentity
    
    UIView.animateWithDuration(kPressedShrinkDuration,
      delay: 0,
      usingSpringWithDamping: kPressedShrinkDamping,
      initialSpringVelocity: 0,
      options: UIViewAnimationOptions.TransitionNone,
      animations: { () -> Void in
        self.layer.transform = CATransform3DScale(self.layer.transform, kPressedShrinkScale, kPressedShrinkScale, 1);
      },
      completion: { (result: Bool) -> Void in
    })
  }
  
  private func scaleOut() {
    UIView.animateWithDuration(kPressedShrinkDuration,
      delay: 0,
      usingSpringWithDamping: kPressedShrinkDamping,
      initialSpringVelocity: 0,
      options: UIViewAnimationOptions.TransitionNone,
      animations: { () -> Void in
        self.transform = CGAffineTransformIdentity
      },
      completion: { (result: Bool) -> Void in
    })
  }
  
  // MARK: - Touch
  
  override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
    scaleIn(touch)
    return super.beginTrackingWithTouch(touch, withEvent: event)
  }
  override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
    scaleOut()
  }
  override func cancelTrackingWithEvent(event: UIEvent?) {
    scaleOut()
  }
}
