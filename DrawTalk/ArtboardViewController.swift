//
//  DWTArtboardViewController.swift
//  DrawTalk
//
//  Created by Kirollos Risk on 10/10/14.
//  Copyright (c) 2014 DrawTalk. All rights reserved.
//

import Foundation
import UIKit

public class ArtboardViewController : UIViewController {

  @IBOutlet weak var messageContainerView: UIView!
  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var sendButton: UIButton!
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public class func controller() -> ArtboardViewController {
    let vc = ArtboardViewController(nibName:"ArtboardViewController", bundle: nil)
    return vc
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()

    let messageController = MessageCollectionViewController.controller()
    addChildViewController(messageController)
    messageContainerView.addSubview(messageController.view)
    messageController.didMoveToParentViewController(self)
    messageContainerView.backgroundColor = UIColor.redColor()
    
    canvasView.viewOnly = true
  }
  
  @IBAction func resetButtonTapped(sender : AnyObject) {
    canvasView.reset()
  }
  
  @IBAction func replayButtonTapped(sender : AnyObject) {
    canvasView.replay()
  }
  
  /*
  private func replay(paths: [DrawTalk.Path]) {
    
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
*/
  
  /*
  private func drawSegmentFromPoint(point: CGPoint, toPoint: CGPoint, brush: CGFloat, color: UIColor, duration: CFTimeInterval, completion: (() -> Void)?) {
    
    println("drawing: \(point), \(toPoint), \(duration)")
    
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
  */
  
  @IBAction func sendButtonTapped(sender : AnyObject) {
    let drawingJson = DrawingJson(drawing: canvasView.drawing())
    // 4086855484
    var message = ChatMessage.outgoing(drawingJson.jsonString(), channel: "6504047096")
    
    MessageEventBus.defaultBus.post(kMessageEventOutgoing, event: message)
    
    //println("here we are", drawingJson.toJson())
    //println(encodedJsonString)
    // https://github.com/mobile-web-messaging/MQTTKit
  }
}
