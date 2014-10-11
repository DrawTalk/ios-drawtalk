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

/*
private class DWTBezierPath: UIBezierPath {
  var timelapse: NSTimeInterval = 0
}
*/

public class DWTArtboardViewController : UIViewController {
  
  @IBOutlet weak var canvasImageView: UIImageView!
  @IBOutlet weak var finalImageView: UIImageView!
  @IBOutlet weak var sendButton: UIButton!
  
  var lastPoint: CGPoint = CGPointZero
  var red : CGFloat = 0.0/255.0
  var green: CGFloat = 0.0/255.0
  var blue: CGFloat = 0.0/255.0
  var brush: CGFloat = 1.0
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
   
    /*
    canvasImageView.image = nil
    finalImageView.image = nil
    
    var pointA : CGPoint?
    var pointB : CGPoint?
    
    for path: Path in paths {
      
      let rgba = path.color.rgbaValues()

      for point: CGPoint in path.coords {
        pointA = point

        UIGraphicsBeginImageContext(view.frame.size)
        canvasImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
        
        // Connect the segment
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), pointA!.x, pointA!.y)
        if pointB != nil {
          CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), pointB!.x, pointB!.y)
        }
        pointB = pointA
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), path.brush)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), rgba.red, rgba.green, rgba.blue, rgba.alpha)
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal)
        
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        canvasImageView.alpha = opacity
        UIGraphicsEndImageContext()
      }
      
      pointA = nil
      pointB = nil
    }
    */
    
    //drawSegment(pointA: CGPointMake(50,50), pointB: CGPointMake(50, 200), completion: nil)

    canvasImageView.image = nil
    finalImageView.image = nil
    
    var pointA : CGPoint?
    var pointB : CGPoint?
    
    typealias Pair = [CGPoint]
    
    var pairs : [Pair] = []
    var parts : [[Pair]] = []
    
    for path: Path in paths {
      let rgba = path.color.rgbaValues()
      for point: CGPoint in path.coords {
        if pointA != nil {
          pairs.append([pointA!, point])
        }
        pointA = point
      }
      pointA = nil
      parts.append(pairs)
    }

    var next : (Int, Int) -> Int = { $1 }
    next = { (section: Int, index: Int) -> Int in
      if (section > parts.count - 1) {
        return 0
      }
      if index > parts[section].count - 1 {
        next(section+1, index+1)
        return 0
      }
      let pair = parts[section][index]
      self.drawSegment(
        pointA: pair[0] as CGPoint,
        pointB: pair[1] as CGPoint,
        completion: { () -> Void in
          var a = next(section, index+1)
      })
      return 1
    }
    
    next(0, 0)
  }
  
  private func drawSegment(#pointA: CGPoint, pointB: CGPoint, completion: (() -> Void)?) {
    println("\(pointA), \(pointB)")
    
    /*
    let rgba =  UIColor.blackColor().rgbaValues()
    
    UIGraphicsBeginImageContext(view.frame.size)
    canvasImageView.image?.drawInRect(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
    
    // Connect the segment
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), pointA.x, pointA.y)
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), pointB.x, pointB.y)
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound)
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5)
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), rgba.red, rgba.green, rgba.blue, rgba.alpha)
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal)
    CGContextStrokePath(UIGraphicsGetCurrentContext())
    canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    canvasImageView.alpha = opacity
    UIGraphicsEndImageContext()
    
    completion!()
    */
    
    // 1) Create bezier path from first point to second.
    var path: UIBezierPath = UIBezierPath()
    path.moveToPoint(pointA)
    path.addLineToPoint(pointB)
    
    /*
    func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
      return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2)
    }
    
    func controlPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
      var controlPoint: CGPoint = midPointForPoints(p1, p2);
      var diffY: CGFloat = abs(p2.y - controlPoint.y);
      
      if p1.y < p2.y {
        controlPoint.y += diffY;
      } else if  p1.y > p2.y {
        controlPoint.y -= diffY;
      }
      return controlPoint;
    }
    let midPoint: CGPoint = midPointForPoints(pointA, pointB);
    path.addQuadCurveToPoint(midPoint, controlPoint:controlPointForPoints(midPoint, pointA))
    path.addQuadCurveToPoint(pointB, controlPoint:controlPointForPoints(midPoint, pointB))
    */

    path.lineJoinStyle = kCGLineJoinRound
    
    // 2) Create a shape layer for above created path.
    var layer: CAShapeLayer = CAShapeLayer()
    layer.strokeColor = UIColor.blackColor().CGColor
    layer.fillColor = UIColor.blackColor().CGColor
    layer.lineWidth = brush
    layer.strokeStart = 0.0
    layer.strokeEnd = 1.0
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
    drawAnimation.duration = 0.01
    drawAnimation.fromValue = 0.0
    drawAnimation.toValue = 1.0
    drawAnimation.timingFunction = CAMediaTimingFunction(name: "linear")
    layer.addAnimation(drawAnimation, forKey:"drawLineAnimation")
    
    CATransaction.commit()
  }

  @IBAction func sendButtonTapped(sender : AnyObject) {
    var data: [DWTPathJSON] = paths.map({ (path: Path) -> DWTPathJSON in
      return path.toJSON()
    })
    println(data)
    
    // https://github.com/mobile-web-messaging/MQTTKit
    
    let host = "tcp://m10.cloudmqtt.com"
    let port : UInt16 = 16056
    let username = "vkgogxez"
    let password = "oX02eF7V0I9Y"
    let topic = "hello/world"
    let qos2 = 2
    
    let clientId = UIDevice.currentDevice().identifierForVendor.UUIDString
    let client: MQTTClient = MQTTClient(clientId: clientId)
    
    client.username = username
    client.password = password
    client.host = host
    client.port = port
    
    client.connectWithCompletionHandler { (code: MQTTConnectionReturnCode) -> Void in
      switch code.value {
      case ConnectionAccepted.value:
        client.publishString(
          "Message from iOS app",
          toTopic: topic,
          withQos: ExactlyOnce,
          retain: false,
          completionHandler: { (mid: Int32) -> Void in
            
        })
        /*
        var payload : NSData = NSKeyedArchiver.archivedDataWithRootObject(data)
        client.publishData(
          payload,
          toTopic: topic,
          withQos: ExactlyOnce,
          retain: false,
          completionHandler: { (mid: Int32) -> Void in
            
        })
        */
        break
      default:
        break
      }
    }
  }
}
