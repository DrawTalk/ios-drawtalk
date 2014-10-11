//
//  DWTArtboardViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import UIKit

typealias DWTPathJSON = Dictionary<String, AnyObject>

struct Path {
  var coords: [CGPoint]
  var color: UIColor = UIColor.blackColor()
  var brush: CGFloat = 1.0
  
  func toJSON() -> DWTPathJSON {
    var arr: [[CGFloat]] = coords.map({ (point: CGPoint) -> [CGFloat] in
      return [point.x, point.y]
    })
    var hex = color.hex()
    var json : DWTPathJSON = [
      "coods": arr,
      "color": hex!,
      "brush": brush
    ]
    return json
  }
}

public class DWTArtboardViewController : UIViewController {
  
  @IBOutlet weak var canvasImageView: UIImageView!
  @IBOutlet weak var finalImageView: UIImageView!
  @IBOutlet weak var sendButton: UIButton!
  
  var lastPoint: CGPoint = CGPointZero
  var red : CGFloat = 0.0/255.0
  var green: CGFloat = 0.0/255.0
  var blue: CGFloat = 0.0/255.0
  var brush: CGFloat = 5.0
  var opacity: CGFloat = 1.0
  
  var currPath: Path?
  var paths: [Path] = []
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required public init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  public class func artboardController() -> DWTArtboardViewController {
    let color = UIColor.blueColor()
    let hex = color.hex()
    println("hex: \(hex)")
    var c = UIColor(rgba: hex!)
    println("color: \(c)")
    return DWTArtboardViewController(nibName:"DWTArtboardViewController", bundle: nil)
  }
  
  public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    let touch : UITouch = touches.anyObject() as UITouch
    lastPoint = touch.locationInView(view)
    
    currPath = Path(
      coords: [lastPoint],
      color: UIColor(red: red, green: green, blue: blue, alpha: opacity),
      brush: brush
    )
  }
  
  public override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    let touch : UITouch = touches.anyObject() as UITouch
    let currentPoint : CGPoint = touch.locationInView(view)
    
    UIGraphicsBeginImageContext(view.frame.size);
    canvasImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext())
    canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    canvasImageView.alpha = opacity
    UIGraphicsEndImageContext();

    lastPoint = currentPoint;
    
    currPath?.coords.append(currentPoint)
  }
  
  public override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    canvasImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();

    
    UIGraphicsBeginImageContext(self.finalImageView.frame.size);
    finalImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
    canvasImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
    finalImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    canvasImageView.image = nil;
    UIGraphicsEndImageContext();
    
    if currPath != nil {
      paths.append(currPath!)
    }
  }
  
  @IBAction func sendButtonTapped(sender : AnyObject) {
    var data: [DWTPathJSON] = paths.map({ (path: Path) -> DWTPathJSON in
      return path.toJSON()
    })
    println(data)
  }
}
