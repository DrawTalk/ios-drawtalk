//
//  DWTArtboardViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

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
  
  private var currPath: DrawTalk.Path?
  private var paths: [DrawTalk.Path] = []
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public class func artboardController() -> DWTArtboardViewController {    
    let vc = DWTArtboardViewController(nibName:"DWTArtboardViewController", bundle: nil)
    
    MessageEventBus.defaultBus.subscribe(kMessageEventIncoming, handler: { (event: MessageEvent) -> Void in
      let chatMessage = event as ChatMessage
      var d = JSON(data: chatMessage.text.dataUsingEncoding(NSUTF8StringEncoding)!)
      var drawingJson =  DrawingJson(json: d)
      dispatch_async(dispatch_get_main_queue(), {
        vc.reset()
        vc.replay(drawingJson.toDrawing())
      })
    })

    return vc
  }
  
  public override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    let touch : UITouch = touches.anyObject() as UITouch
    lastPoint = touch.locationInView(view)
    
    currPath = DrawTalk.Path(
      coords: [lastPoint],
      color: UIColor(red: red, green: green, blue: blue, alpha: opacity),
      brush: brush,
      duration: NSDate.timeIntervalSinceReferenceDate()
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
    
    if var p: DrawTalk.Path = currPath {
      p.duration = (NSDate.timeIntervalSinceReferenceDate() - p.duration) / Double(p.coords.count)
      paths.append(p)
    }
  }
  
  @IBAction func resetButtonTapped(sender : AnyObject) {
    reset()
  }
  
  @IBAction func replayButtonTapped(sender : AnyObject) {
    replay(paths)
  }
  
  public func reset() {
    paths.removeAll(keepCapacity: false)
    clear()
  }
  
  public func clear() {
    canvasImageView.image = nil
    finalImageView.image = nil
    finalImageView.layer.sublayers = nil
  }
  
  public func replay(drawing: Drawing) {
    let newDrawing = normalize(drawing)
    replay(newDrawing.paths)
  }
  
  private func normalize(drawing: Drawing) -> Drawing {
    var newDrawing = Drawing()
    
    let size = finalImageView.frame.size
    
    var newGrid = CGSizeZero
    var offset = CGPointZero
    
    var factor: CGFloat = 1
    let currentRatio = size.width / size.height;
    let otherRatio = drawing.grid.width / drawing.grid.height;
    
    if otherRatio > currentRatio {
      factor = size.width / drawing.grid.width
      newGrid = CGSizeMake(size.width, size.width / otherRatio)
      offset = CGPointMake(0, (size.height - newGrid.height) / 2)
    } else {
      factor = size.height / drawing.grid.height
      newGrid = CGSizeMake(size.height * otherRatio, size.height)
      offset = CGPointMake((size.width - newGrid.width) / 2, 0)
    }
    
    newDrawing.paths = drawing.paths.map { (path: DrawTalk.Path) -> DrawTalk.Path in
      var newPath = Path()
      newPath.color = path.color
      newPath.brush = path.brush
      newPath.duration = path.duration
      newPath.coords = path.coords.map({ (point: CGPoint) -> CGPoint in
        return CGPointMake(point.x * factor + offset.x, point.y * factor + offset.y)
      })
      return newPath
    }
    
    return newDrawing
  }
  
  func replay(paths: [DrawTalk.Path]) {
    
    clear()
    
    struct PairsInfo {
      var pairs: [DrawTalk.Pair] = []
      var brush: CGFloat = self.brush
      var color: UIColor = UIColor.blackColor()
      var duration: CFTimeInterval = 0.01
    }
    
    var drawings: [PairsInfo] = []
    
    var prevPoint: CGPoint?
    for path: DrawTalk.Path in paths {
      /*
      var p: [DrawTalk.Pair] = path.pairs()
      for x: DrawTalk.Pair in p {
        println("here", x.pointA, x.pointB)
      }
      */
      drawings.append(PairsInfo(pairs: path.pairs(), brush: path.brush, color: path.color, duration: path.duration))
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
        duration: info.duration,
        completion: { () -> Void in
          next(section, index+1)
      })
    }
    
    next(0, 0)
  }
  
  private func drawSegmentFromPoint(point: CGPoint, toPoint: CGPoint, brush: CGFloat, color: UIColor, duration: CFTimeInterval, completion: (() -> Void)?) {
    
    //println("drawing: \(point), \(toPoint), \(duration)")
    
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
    let size = finalImageView.frame.size
    
    let drawing = Drawing(paths: paths, grid: size)
    let drawingJson = DrawingJson(drawing: drawing)
    var message = ChatMessage.outgoing(drawingJson.jsonString())
    
    MessageEventBus.defaultBus.post(kMessageEventOutgoing, event: message)
    
    //println("here we are", drawingJson.toJson())
    //println(encodedJsonString)
    // https://github.com/mobile-web-messaging/MQTTKit
  }
}
