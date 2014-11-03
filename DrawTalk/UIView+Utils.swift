//
//  UIView+Utils.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/2/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func round(diameter: CGFloat) {
    //let savedCenter = self.center
    //let f = CGRectMake(self.frame.origin.x, self.frame.origin.y, diameter, diameter)
    //self.frame = f
    self.layer.cornerRadius = diameter / 2.0
    self.clipsToBounds = true
    //self.center = savedCenter
  }
}