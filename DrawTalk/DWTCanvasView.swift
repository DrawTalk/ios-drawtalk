//
//  DWTCanvasView.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/19/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

private struct Line {
  let p1: CGPoint
  let p2: CGPoint
  var m: CGFloat {
    get {
      return (p2.y - p1.y) / (p2.x - p1.x)
    }
  }
  var b: CGFloat {
    get {
      return p1.y - m * p1.x
    }
  }
}


public class DWTCanvasView: UIView {

  //@IBOutlet weak var containerView: UIView!
  //@IBOutlet weak var drawingImageView: UIImageView!
  //@IBOutlet weak var copyImageView: UIImageView!
  
  private var contentView: UIView!
  private var drawingImageView: UIImageView!
  private var copyImageView: UIImageView!
  
  private var lastPoint: CGPoint = CGPointZero
  
  private var red : CGFloat = 0.0/255.0
  private var green: CGFloat = 0.0/255.0
  private var blue: CGFloat = 0.0/255.0
  
  private var brush: CGFloat = 5.0
  private var opacity: CGFloat = 1.0
  
  private var currPath: DrawTalk.Path?
  private var paths: [DrawTalk.Path] = []
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  
  /*
  override public func awakeFromNib() {
    super.awakeFromNib()
  }
  */
  
  private func setupUI() {
    contentView = UIView()
    drawingImageView = UIImageView()
    copyImageView = UIImageView()

    addSubview(contentView)
    contentView.addSubview(copyImageView)
    contentView.addSubview(drawingImageView)
    
    contentView.setTranslatesAutoresizingMaskIntoConstraints(true)
    contentView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
    contentView.frame = self.bounds
    
    drawingImageView.setTranslatesAutoresizingMaskIntoConstraints(true)
    drawingImageView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
    drawingImageView.frame = contentView.bounds
    
    copyImageView.setTranslatesAutoresizingMaskIntoConstraints(true)
    copyImageView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
    copyImageView.frame = contentView.bounds
  }
  
  override public func updateConstraints() {
    super.updateConstraints()
  }
  
  override public func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    let touch : UITouch = touches.anyObject() as UITouch
    lastPoint = touch.locationInView(self)
    
    currPath = DrawTalk.Path(
      coords: [lastPoint],
      color: UIColor(red: red, green: green, blue: blue, alpha: opacity),
      brush: brush,
      duration: NSDate.timeIntervalSinceReferenceDate()
    )
  }
  
  override public func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    let touch : UITouch = touches.anyObject() as UITouch
    let currentPoint : CGPoint = touch.locationInView(self)
    
    UIGraphicsBeginImageContext(self.frame.size)
    drawingImageView.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound)
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush)
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0)
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal)
    
    CGContextStrokePath(UIGraphicsGetCurrentContext())
    drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    drawingImageView.alpha = opacity
    UIGraphicsEndImageContext()
    
    lastPoint = currentPoint;
    
    currPath?.coords.append(currentPoint)
  }
  
  override public func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    UIGraphicsBeginImageContext(self.frame.size);
    drawingImageView.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    UIGraphicsBeginImageContext(copyImageView.frame.size)
    copyImageView.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
    drawingImageView.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
    copyImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    drawingImageView.image = nil
    UIGraphicsEndImageContext()
    
    if var p: DrawTalk.Path = currPath {
      p.duration = (NSDate.timeIntervalSinceReferenceDate() - p.duration) / Double(p.coords.count)
      paths.append(p)
    }
  }
  
  func reset() {
    paths.removeAll(keepCapacity: false)
    clear()
  }
  
  func clear() {
    drawingImageView.image = nil
    copyImageView.image = nil
    copyImageView.layer.sublayers = nil
  }
  
  func replay() {
    replay(paths)
  }
  
  func replay(drawing: Drawing) {
    let newDrawing = drawing.normalizedToSize(copyImageView.frame.size)
    replay(newDrawing.paths)
  }
  
  func replay(paths: [DrawTalk.Path]) {
    clear()
    
    var path: UIBezierPath = UIBezierPath()
    path.lineJoinStyle = kCGLineJoinRound
    
    var next: ((Int, Int) -> Void)!
    next = { (section: Int, index: Int) -> Void in
      
      if section > paths.count - 1 {
        return
      }
      let p = paths[section]
      let coords = p.coords
      if index > coords.count - 1 {
        next(section+1, 0)
        return
      }
      
      let point: CGPoint = coords[index]
      
      if (index > 0) {
        var path: UIBezierPath = UIBezierPath()
        path.lineJoinStyle = kCGLineJoinRound
        path.moveToPoint(coords[index-1])
        
        if index % 2 == 0 && ((index + 1) < (coords.count - 1)) {
          // Get necessary points
          var a = coords[index-2]
          var b = coords[index-1]
          var c = coords[index+1]
          
          let l1 = Line(p1: a, p2: b)
          let l2 = Line(p1: point, p2: c)
          
          // When slope is undefined or zero
          if a.x == b.x || c.x == point.x || l1.m == l2.m {
            path.addLineToPoint(point)
          } else {
            // Get intersection
            let x = (l2.b - l1.b) / (l1.m - l2.m)
            let y = (l1.m * x) + l1.b
            let intersection = CGPointMake(x, y)
            path.addQuadCurveToPoint(point, controlPoint: intersection)
          }
          
          //println("a \(a)")
          //println("b \(b)")
          //println("p \(point)")
          //println("c \(c)")
          //println("c1 \(intersection)")
        } else {
          path.addLineToPoint(point)
        }
        
        self.animatePath(
          path,
          brush: p.brush,
          color: p.color,//index % 2 == 0 ? p.color : UIColor.redColor(),
          duration: p.duration,
          completion: { () -> Void in
            next(section, index+1)
        })
      } else {
        next(section, index+1)
      }
    }
    
    next(0, 0)
  }
  
  private func animatePath(path: UIBezierPath, brush: CGFloat, color: UIColor, duration: CFTimeInterval, completion: (() -> Void)?) {
    // 2) Create a shape layer for above created path.
    var layer: CAShapeLayer = CAShapeLayer()
    layer.strokeColor = color.CGColor
    //layer.fillColor = color.CGColor
    layer.lineWidth = brush
    //layer.strokeStart = 0.0
    //layer.strokeEnd = 1.0
    layer.lineCap = kCALineCapRound
    layer.path = path.CGPath
    copyImageView.layer.addSublayer(layer)
    
    // 3) Animate the path
    CATransaction.begin()
    
    CATransaction.setCompletionBlock { () -> Void in
      if completion != nil {
        completion!()
      }
    }
    var drawAnimation: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
    drawAnimation.duration = duration
    drawAnimation.fromValue = 0
    drawAnimation.toValue = 1.0
    drawAnimation.timingFunction = CAMediaTimingFunction(name: "linear")
    layer.addAnimation(drawAnimation, forKey:"drawLineAnimation")
    
    CATransaction.commit()
  }
  
  func drawing() -> Drawing {
    let size = self.frame.size
    let drawing = Drawing(paths: paths, grid: size)
    return drawing
  }
}