//
//  UIImage+Utils.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 11/2/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

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