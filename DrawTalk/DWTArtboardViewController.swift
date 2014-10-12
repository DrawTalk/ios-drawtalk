//
//  DWTArtboardViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

typealias DWTPathJSON = Dictionary<String, AnyObject>

private struct DWTPair {
  var pointA: CGPoint
  var pointB: CGPoint
}

private struct DWTPath {
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
  
  func pairs() -> [DWTPair] {
    var prevPoint: CGPoint?
    var pairs: [DWTPair] = []
    for point: CGPoint in coords {
      if prevPoint != nil {
        pairs.append(DWTPair(pointA: prevPoint!, pointB: point))
      }
      prevPoint = point
    }
    return pairs
  }
}

/*
private class DWTBezierPath: UIBezierPath {
  var timelapse: NSTimeInterval = 0
}
*/

public class DWTArtboardViewController : UIViewController {
  
  @IBOutlet weak var canvasImageView: UIImageView!
  @IBOutlet weak var finalImageView: UIImageView!
  @IBOutlet weak var sendButton: UIButton!
  
  private var lastPoint: CGPoint = CGPointZero
  
  private var red : CGFloat = 0.0/255.0
  private var green: CGFloat = 0.0/255.0
  private var blue: CGFloat = 0.0/255.0
  
  private var brush: CGFloat = 5.0
  private var opacity: CGFloat = 1.0
  
  private var currPath: DWTPath?
  private var paths: [DWTPath] = []
  
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
    
    currPath = DWTPath(
      coords: [lastPoint],
      color: UIColor(red: red, green: green, blue: blue, alpha: opacity),
      brush: brush
    )
  }
  
  public override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    let touch : UITouch = touches.anyObject() as UITouch
    let currentPoint : CGPoint = touch.locationInView(view)
    
    UIGraphicsBeginImageContext(view.frame.size)
    canvasImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound)
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush)
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0)
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal)
    
    CGContextStrokePath(UIGraphicsGetCurrentContext())
    canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    canvasImageView.alpha = opacity
    UIGraphicsEndImageContext()
    
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
    UIGraphicsEndImageContext()
    
    
    UIGraphicsBeginImageContext(self.finalImageView.frame.size)
    finalImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
    canvasImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
    finalImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    canvasImageView.image = nil
    UIGraphicsEndImageContext()
    
    if currPath != nil {
      paths.append(currPath!)
    }
  }
  
  @IBAction func replayButtonTapped(sender : AnyObject) {
    
    canvasImageView.image = nil
    finalImageView.image = nil
    finalImageView.layer.sublayers = nil

    struct PairsInfo {
      var pairs: [DWTPair] = []
      var brush: CGFloat = self.brush
      var color: UIColor = UIColor.blackColor()
    }
    
    var drawings: [PairsInfo] = []
    
    var prevPoint: CGPoint?
    for path: DWTPath in paths {
      drawings.append(PairsInfo(pairs: path.pairs(), brush: path.brush, color: path.color))
    }
    
    var currBrush = brush
    var currColor = UIColor.blackColor()
    
    var next: ((Int, Int) -> Void)!
    next = { (section: Int, index: Int) -> Void in
      if (section > drawings.count - 1) {
        return
      }
      
      let info: PairsInfo = drawings[section]
      
      if index > info.pairs.count - 1 {
        next(section+1, 0)
        return
      }
      
      let pair = info.pairs[index]

      self.drawSegmentFromPoint(
        pair.pointA,
        toPoint: pair.pointB,
        brush: info.brush,
        color: info.color,
        duration: 0.01,
        completion: { () -> Void in
          next(section, index+1)
      })
    }
    
    next(0, 0)
  }
  
  private func drawSegmentFromPoint(point: CGPoint, toPoint: CGPoint, brush: CGFloat, color: UIColor, duration: CFTimeInterval, completion: (() -> Void)?) {
    println("\(point), \(toPoint)")

    // 1) Create bezier path from first point to second.
    var path: UIBezierPath = UIBezierPath()
    path.moveToPoint(point)
    path.addLineToPoint(toPoint)
    path.lineJoinStyle = kCGLineJoinRound
    
    // 2) Create a shape layer for above created path.
    var layer: CAShapeLayer = CAShapeLayer()
    layer.strokeColor = color.CGColor
    layer.fillColor = color.CGColor
    layer.lineWidth = brush
    layer.strokeStart = 0.0
    layer.strokeEnd = 1.0
    layer.lineCap = kCALineCapRound
    layer.path = path.CGPath
    finalImageView.layer.addSublayer(layer)
    
    // 3) Animate the path
    CATransaction.begin()
    CATransaction.setCompletionBlock { () -> Void in
      if completion != nil {
        completion!()
      }
    }
    var drawAnimation: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
    drawAnimation.duration = duration
    drawAnimation.fromValue = 0.0
    drawAnimation.toValue = 1.0
    drawAnimation.timingFunction = CAMediaTimingFunction(name: "linear")
    layer.addAnimation(drawAnimation, forKey:"drawLineAnimation")
    
    CATransaction.commit()
  }

  @IBAction func sendButtonTapped(sender : AnyObject) {
    var data: [DWTPathJSON] = paths.map({ (path: DWTPath) -> DWTPathJSON in
      return path.toJSON()
    })
    
    println(data)
    
    var jsonError: NSError?
    let encodedJsonData: NSData? = NSJSONSerialization.dataWithJSONObject(data, options: nil, error: &jsonError)
    let encodedJsonString: NSString = NSString(data:encodedJsonData!, encoding:NSUTF8StringEncoding)
    
    println(encodedJsonString)
    
    DWTMqttWrapper.sendMessage(encodedJsonString)
    
    // https://github.com/mobile-web-messaging/MQTTKit
  }
}
